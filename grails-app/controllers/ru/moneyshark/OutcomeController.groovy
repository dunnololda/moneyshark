package ru.moneyshark

import org.springframework.dao.DataIntegrityViolationException

class OutcomeController {

    static allowedMethods = [save: "POST", update: "POST", delete: "GET"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [outcomeInstanceList: Outcome.list(params), outcomeInstanceTotal: Outcome.count()]
    }

    def create() {
        [outcomeInstance: new Outcome(params)]
    }

    def save() {
        def outcomeInstance = new Outcome(params)
		outcomeInstance.status = "accepted"
		outcomeInstance.user = session.user
        if (!outcomeInstance.save(flush: true)) {
            render(view: "create", model: [outcomeInstance: outcomeInstance])
            return
        } else {
			// updating balance
			def current_balance = Balance.list(sort:"id", order:"desc", max:1)?.find{it}?.balance?:0
			def new_balance = new Balance(balance:current_balance-outcomeInstance.amount, date:outcomeInstance.date, user:session.user, comment:outcomeInstance.comment)
			new_balance.save(failOnError: true/*flush:true*/)
		}

		flash.message = message(code: 'default.created.message', args: [message(code: 'outcome.label', default: 'Outcome'), outcomeInstance.id])
        redirect(action: "list")
    }

    def show() {
        def outcomeInstance = Outcome.get(params.id)
        if (!outcomeInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'outcome.label', default: 'Outcome'), params.id])
            redirect(action: "list")
            return
        }

        [outcomeInstance: outcomeInstance]
    }

    def edit() {
        def outcomeInstance = Outcome.get(params.id)
        if (!outcomeInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'outcome.label', default: 'Outcome'), params.id])
            redirect(action: "list")
            return
        }

        [outcomeInstance: outcomeInstance]
    }

    def update() {
        def outcomeInstance = Outcome.get(params.id)
        if (!outcomeInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'outcome.label', default: 'Outcome'), params.id])
            redirect(action: "list")
            return
        }

        if (params.version) {
            def version = params.version.toLong()
            if (outcomeInstance.version > version) {
                outcomeInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'outcome.label', default: 'Outcome')] as Object[],
                          "Another user has updated this Outcome while you were editing")
                render(view: "edit", model: [outcomeInstance: outcomeInstance])
                return
            }
        }

		def old_amount = outcomeInstance.amount
        outcomeInstance.properties = params

        if (!outcomeInstance.save(flush: true)) {
            render(view: "edit", model: [outcomeInstance: outcomeInstance])
            return
        } else {
			// updating balance
			def balances = Balance.findAllByDateGreaterThanEquals(outcomeInstance.date)
			balances.each {
				it.balance += old_amount
				it.balance -= outcomeInstance.amount
				it.comment += " ("+"Обновлено: "+outcomeInstance.comment+")"
				it.save(failOnError: true)
			}		
		}

		flash.message = message(code: 'default.updated.message', args: [message(code: 'outcome.label', default: 'Outcome'), outcomeInstance.id])
        redirect(action: "list")
    }

    def delete() {
        def outcomeInstance = Outcome.get(params.id)
        if (!outcomeInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'outcome.label', default: 'Outcome'), params.id])
            redirect(action: "list")
            return
        }

        try {
            outcomeInstance.delete(flush: true)
			
			// updating balance
			def balances = Balance.findAllByDateGreaterThanEquals(outcomeInstance.date)
			balances.each {
				it.balance += outcomeInstance.amount
				it.comment += " ("+"Отменено: "+outcomeInstance.comment+")"
				it.save(failOnError: true)
			}
			
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'outcome.label', default: 'Outcome'), params.id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
			flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'outcome.label', default: 'Outcome'), params.id])
            redirect(action: "show", id: params.id)
        }
    }
}

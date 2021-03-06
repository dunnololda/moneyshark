
<%@ page import="ru.moneyshark.Outcome" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'outcome.label', default: 'Outcome')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<div class="nav" role="navigation">
			<span class="menuButton">
		   		<g:link class="create" controller="income" action="create">
		   			<g:message code="income.new.label" />
		   		</g:link>
		   	</span>
		   	<span class="menuButton">
		   		<g:link class="create" controller="periodicIncome" action="create">
		   			<g:message code="periodicincome.new.label" />
		   		</g:link>
		   	</span>
			<span class="menuButton">
		   		<g:link class="create" controller="outcome" action="create">
		   			<g:message code="outcome.new.label" />
		   		</g:link>
		   	</span>
		   	<span class="menuButton">
		   		<g:link class="create" controller="periodicOutcome" action="create">
		   			<g:message code="periodicoutcome.new.label" />
		   		</g:link>
		   	</span>
		</div>
		<div id="list-outcome" class="content scaffold-list" role="main">
			<h1><g:message code="outcome.list.label" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="amount" title="${message(code: 'amount.label')}" />
					
						<g:sortableColumn property="comment" title="${message(code: 'comment.label')}" />
						
						<g:sortableColumn property="status" title="${message(code: 'status.label')}" />
					
						<g:sortableColumn property="date" title="${message(code: 'date.label')}" />
					
						<th class="sortable">${message(code: 'default.actions.label', default: 'Actions')}</th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${outcomeInstanceList}" status="i" var="outcomeInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="edit" id="${outcomeInstance.id}">${fieldValue(bean: outcomeInstance, field: "amount")}</g:link></td>
					
						<td><g:link action="edit" id="${outcomeInstance.id}">${fieldValue(bean: outcomeInstance, field: "comment")}</g:link></td>
						
						<td><g:link action="edit" id="${outcomeInstance.id}">${fieldValue(bean: outcomeInstance, field: "status")}</g:link></td>
					
						<td><g:link action="edit" id="${outcomeInstance.id}"><g:formatDate date="${outcomeInstance.date}" /></g:link></td>
					
						<td>
	                        	<div>
	                        		<g:if test="${outcomeInstance.status == "waiting"}">
	                        		<span class="menuButton" onclick="return confirm('\${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
		                        		<g:link class="accept"
		                        				controller="outcome" 
		                        				action="accept"
		                        				title="Accept"  
		                        				id="${outcomeInstance?.id}" />		                        		
	                        		</span>
	                        		</g:if>
	                        		<span class="menuButton" onclick="return confirm('\${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
		                        		<g:link class="delete" 
		                        				action="delete"
		                        				title="Delete"  
		                        				id="${outcomeInstance?.id}" />		                        		
	                        		</span>
                        		</div>
                        </td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="paginateButtons">
				<g:paginate total="${outcomeInstanceTotal}" />
				<g:gridrows max="10,100,500,${outcomeInstanceTotal}" controller="outcome" />
			</div>
		</div>
	</body>
</html>

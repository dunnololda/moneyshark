<%@ page import="ru.moneyshark.User" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
		<title><g:message code="default.edit.label" args="[entityName]" /></title>
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
		<div id="edit-user" class="content scaffold-edit" role="main">
			<h1><g:message code="user.edit.label" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${userInstance}">
	            <div class="errors">
	                <g:renderErrors bean="${userInstance}" as="list" />
	            </div>
            </g:hasErrors>
			<g:form method="post" >
				<g:hiddenField name="id" value="${userInstance?.id}" />
				<g:hiddenField name="version" value="${userInstance?.version}" />
				<div class="form">
					<table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="password"><g:message code="user.newpassword.label" default="Password" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'password', 'errors')}">
                                    <g:passwordField name="password" value="" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="password.again"><g:message code="user.newpasswordagain.label"  /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'password', 'errors')}">
                                    <g:passwordField name="password_again" value="" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
				</div>
				<div class="buttons">
					<g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" />
				</div>
			</g:form>
		</div>
		<div id="list-promocodes" class="content scaffold-list" role="main">
			<h1><g:message code="user.promocodes.label" /></h1>
			<table>
				<thead>
					<tr>				
						<g:sortableColumn property="promocode" title="${message(code: 'user.promocode.label')}" />				
						<g:sortableColumn property="usedFor" title="${message(code: 'user.promocode.used.label')}" />				
					</tr>
				</thead>
				<tbody>
				<g:each in="${promos}" status="i" var="promoInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">				
						<td>${fieldValue(bean: promoInstance, field: "promocode")}</td>				
						<td>${fieldValue(bean: promoInstance, field: "usedFor")}</td>                       
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="paginateButtons">
				<g:if test="${availablePromos}">
				<span class="menuButton">
		            <g:link 
		            	controller="user"
		                class="create" 
						action="generatePromo">
						${message(code: 'user.generatepromo.label', default:'Generate Promocode')}
					</g:link>
				</span>
				</g:if>
				<g:else>
     				${message(code: 'user.nextpromo.label', default:'Next promocode creation will be available when less than 10 of these will be free')}
				</g:else>
			</div>
		</div>
	</body>
</html>

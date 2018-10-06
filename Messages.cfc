<cfcomponent>
	<cffunction name="createResponse">
		<cfargument name="regid" required="yes"  />		
		<cfargument name="messageId" required="yes"  />		
		<cfargument name="message" required="yes"  />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="clientId" required="yes" />
		<cfquery name="q" dataSource="#request.dsn#">
			insert into dbo.app_message_replies(
				message_id, sender_id, message, create_date,
				event_id, client_id, active
			)
			values(
				<cfqueryparam value="#messageId#" />,
				<cfqueryparam value="#regId#" />,
				<cfqueryparam value="#message#" />,
				getdate(),
				<cfqueryparam value="#eventid#" />,
				<cfqueryparam value="#clientid#" />,
				1
			)
		</cfquery>
	</cffunction>

	<cffunction name="createMessage">
		<cfargument name="regid" required="yes"  />		
		<cfargument name="contactid" required="yes"  />		
		<cfargument name="subject" required="yes"  />		
		<cfargument name="message" required="yes"  />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="clientId" required="yes" />
		<cfquery name="q" dataSource="#request.dsn#">
			insert into dbo.app_messages(
				subject, message, creator_id, create_date,
				recipient_id, event_id, client_id, active
			)
			values(
				<cfqueryparam value="#subject#" />,
				<cfqueryparam value="#message#" />,
				<cfqueryparam value="#regid#" />,
				getdate(),
				<cfqueryparam value="#contactid#" />,
				<cfqueryparam value="#eventid#" />,
				<cfqueryparam value="#clientid#" />,
				1
			)
		</cfquery>
	</cffunction>

	<cffunction name="getMessages">
		<cfargument name="regid" required="yes"  />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="clientId" required="yes" />
		<cfquery name="q" dataSource="#request.dsn#"  cachedWithin="#CreateTimeSpan(0, 0, 5, 0)#">
			select distinct m.id, m.subject, m.message, m.creator_id, m.create_date,
				m.recipient_id, m.event_id, m.client_id, r.first_name + ' ' + r.last_name as [to]
			from dbo.app_messages m
			inner join dbo.registrations r on r.reg_id = m.recipient_id
			where 
			active = 1 
			AND ( 
				creator_id = <cfqueryparam value="#regid#" />
				OR recipient_id = <cfqueryparam value="#regid#" />
			)
			order by create_date desc
		</cfquery>
		<Cfreturn q />
	</cffunction>	


	<cffunction name="getResponses">
		<cfargument name="messageId" required="yes"  />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="clientId" required="yes" />
		<cfquery name="q" dataSource="#request.dsn#"  cachedWithin="#CreateTimeSpan(0, 0, 5, 0)#">
			select m.id, m.message_id,  m.message, m.create_date,
				m.sender_id, m.event_id, m.client_id, sender.first_name + ' ' + sender.last_name as sender
			from dbo.app_message_replies m
			inner join dbo.registrations sender on sender.reg_id = m.sender_id
			where 
			active = 1 
			and m.message_id = <cfqueryparam value="#messageid#" />
			order by create_date desc
		</cfquery>
		<Cfreturn q />
	</cffunction>

	<cffunction name="getMessage">
		<cfargument name="regid" required="yes"  />		
		<cfargument name="messageId" required="yes"  />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="clientId" required="yes" />
		<cfquery name="q" dataSource="#request.dsn#">
			select top 1 m.id, m.subject, m.message, m.creator_id, m.create_date,
				m.recipient_id, m.event_id, m.client_id, r.first_name + ' ' + r.last_name as [to],
				sender.first_name + ' ' + sender.last_name as sender
			from dbo.app_messages m
			inner join dbo.registrations r on r.reg_id = m.recipient_id
			inner join dbo.registrations sender on sender.reg_id = m.creator_id
			where 
			active = 1 
			and m.id = <cfqueryparam value="#messageid#" />
			order by create_date desc
		</cfquery>
		<Cfreturn q />
	</cffunction>	

	<cffunction name="deleteMessage">
		<cfargument name="messageid" required="yes"  />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="clientId" required="yes" />
		<cfquery name="q" dataSource="#request.dsn#">
			update dbo.app_messages
			set active = 0
			where id = <cfqueryparam value="#messageid#" />
		</cfquery>
	</cffunction>	

</cfcomponent>
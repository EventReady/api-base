<cfcomponent>
	<cffunction name="getContacts" access="public" output="no">
		<cfargument name="eventId" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#" cachedWithin="#CreateTimeSpan(0, 1, 0, 0)#">
				SELECT r.first_name + ' ' + r.last_name as full_name, r.*
				FROM dbo.XR_Reg_Events as x
				inner join dbo.registrations as r on r.reg_ID = x.reg_id
				where event_id = <cfqueryparam value="#arguments.eventId#" />
		</cfquery>
		<Cfreturn q />
	</cffunction>
</cfcomponent>
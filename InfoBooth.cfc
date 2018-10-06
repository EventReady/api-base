<cfcomponent>
	<cffunction name="getInfoBooth" access="public" output="no">
		<cfargument name="clientId" required="yes" />
		<cfargument name="eventId" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#" cachedWithin="#CreateTimeSpan(0, 0, 5, 0)#">
			select * from dbo.app_info_booth
			where client_id = <cfqueryparam value="#clientid#" /> 
			and event_id = <cfqueryparam value="#eventId#" /> 
			and active = 1
			order by title
		</cfquery>
		<Cfreturn q />
	</cffunction>

</cfcomponent>
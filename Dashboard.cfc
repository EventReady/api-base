<cfcomponent>
	<cffunction name="getCallout" access="public" output="no">
		<cfargument name="event_id" required="yes" />
		<cfquery name="q" dataSource="#request.dsn#" cachedWithin="#CreateTimeSpan(0, 1, 0, 0)#">
			select top 1 * from dbo.app_callouts
			where active = 1 and event_id = <cfqueryparam value="#arguments.event_id#" />
		</cfquery>
		<Cfreturn q />
	</cffunction>
	<cffunction name="getSpotlight" access="public" output="no">
		<cfargument name="event_id" required="yes" />
		<cfquery name="q" dataSource="#request.dsn#" cachedWithin="#CreateTimeSpan(0, 1, 0, 0)#">
			select top 1 * from dbo.app_spotlight
			where active = 1 and event_id = <cfqueryparam value="#arguments.event_id#" />
		</cfquery>
		<Cfreturn q />
	</cffunction>	
</cfcomponent>


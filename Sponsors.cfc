 <cfcomponent>
	<cffunction name="getSponsor" access="public" output="no">
		<cfargument name="sponsorId" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#">
			select * from dbo.app_sponsors
			where id = <cfqueryparam value="#sponsorId#" />
		</cfquery>
		<Cfreturn q />
	</cffunction>

	<cffunction name="getSponsors" access="public" output="no">
		<cfargument name="clientId" required="yes" />		
		<cfargument name="eventId" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#"  cachedWithin="#CreateTimeSpan(0, 1, 0, 0)#">
			SELECT *
			FROM app_sponsors
			WHERE event_id = <cfqueryparam value="#eventId#" /> 
			and active = 1
			order by name
		</cfquery>
		<Cfreturn q />
	</cffunction>

</cfcomponent>
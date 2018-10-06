<cfcomponent>
	<cffunction name="getVenue" access="public" output="no">
		<cfargument name="venueId" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#">
			select * from dbo.venues
			where venue_id = <cfqueryparam value="#venueId#" />
		</cfquery>
		<Cfreturn q />
	</cffunction>

	<cffunction name="getVenues" access="public" output="no">
		<cfargument name="clientId" required="yes" />		
		<cfargument name="eventId" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#">
			SELECT *
			FROM Venues
			WHERE Client_ID = <cfqueryparam value="#clientId#" />
			and has_Approved = 'Yes'
		</cfquery>
		<Cfreturn q />
	</cffunction>

</cfcomponent>
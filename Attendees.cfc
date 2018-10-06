<cfcomponent>
	<cffunction name="getAttendees" access="public" output="no">
		<cfargument name="clientId" required="yes" />
		<cfargument name="eventId" required="yes" />
		<cfargument name="start" required="yes" default="0" />
		<cfargument name="end" required="yes" default="0" />
		<cfargument name="term" required="no" default="" />
				
		<cfquery name="q" dataSource="#request.dsn#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
			WITH Attendees AS(

				SELECT r.first_name, r.last_name, r.email, r.first_name + ' ' + r.last_name as fullname, r.reg_id,
				ROW_NUMBER() OVER (ORDER BY last_name) AS 'RowNumber'
				FROM dbo.XR_Reg_Events as x
				inner join dbo.registrations as r on r.reg_ID = x.reg_id
				where event_id = <cfqueryparam value="#arguments.eventId#" />
			) 
			SELECT * 
			FROM Attendees 
			<Cfif !len(arguments.term)>		
			WHERE RowNumber BETWEEN <cfqueryparam value="#arguments.start#" /> AND <cfqueryparam value="#arguments.end#" />
			<cfelseif len(arguments.term)>
				where fullname like <cfqueryparam value="%#arguments.term#%" /> 
			</cfif>
			order by last_name asc
		</cfquery>
		<Cfreturn q />
	</cffunction>

	<cffunction name="getAttendee" access="public" output="no">
		<cfargument name="clientId" required="yes" />
		<cfargument name="eventId" required="yes" />
		<cfargument name="attendeeId" required="yes" />
				
		<cfquery name="q" dataSource="#request.dsn#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
			SELECT r.first_name, r.last_name, r.email, r.first_name + ' ' + r.last_name as fullname, r.reg_id
			FROM dbo.XR_Reg_Events as x
			inner join dbo.registrations as r on r.reg_ID = x.reg_id
			where event_id = <cfqueryparam value="#arguments.eventId#" />
			and r.reg_id = <cfqueryparam value="#arguments.attendeeId#" />
		</cfquery>
		<Cfreturn q />
	</cffunction>
</cfcomponent>
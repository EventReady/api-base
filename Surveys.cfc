<cfcomponent>
	<cffunction name="getSurveys" access="public" output="no">
		<cfargument name="clientId" required="yes" />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="startDate" required="yes" />		
		<cfargument name="endDate" required="yes" />		

		<cfquery name="q" dataSource="#request.dsn#">
			select * from dbo.app_survey_questions
			where client_id = <cfqueryparam value="#clientid#" />
			and event_id = <cfqueryparam value="#eventid#" />
			and start_date >= <cfqueryparam value="#startDate#" />
			and end_date <= <cfqueryparam value="#endDate#" />
			order by sort			
		</cfquery>
		<Cfreturn q />
	</cffunction>

	<cffunction name="getSurveyAnswer" access="public" output="no">
		<cfargument name="clientId" required="yes" />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="regid" required="yes" />		
		<cfargument name="surveyid" required="yes" />		

		<cfquery name="q" dataSource="#request.dsn#">
			select * from dbo.app_survey_answers
			where client_id = <cfqueryparam value="#clientid#" />
			and event_id = <cfqueryparam value="#eventid#" />
			and reg_id = <cfqueryparam value="#regid#" />
			and survey_id = <cfqueryparam value="#surveyid#" />
		</cfquery>
		<Cfreturn q />
	</cffunction>

	<cffunction name="addSurveyAnswer" access="public" output="no">
		<cfargument name="clientId" required="yes" />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="regid" required="yes" />		
		<cfargument name="surveyid" required="yes" />		
		<cfargument name="answer" required="yes" />		

		<cfquery name="q" dataSource="#request.dsn#">
			insert into dbo.app_survey_answers(
				client_id, event_id, survey_answer, reg_id, survey_id, insert_date
			)
			values(
				<cfqueryparam value="#clientId#" />, 	
				<cfqueryparam value="#eventId#" />, 	
				<cfqueryparam value="#answer#" />, 	
				<cfqueryparam value="#regid#" />, 	
				<cfqueryparam value="#surveyid#" />,
				getDate()				
			)
		</cfquery>
	</cffunction>


	<cffunction name="saveSurveyAnswer" access="public" output="no">
		<cfargument name="clientId" required="yes" />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="regid" required="yes" />		
		<cfargument name="surveyid" required="yes" />		
		<cfargument name="answer" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#">
			update dbo.app_survey_answers
			SET
				survey_answer = <cfqueryparam value="#answer#" />
			WHERE
				reg_id = <cfqueryparam value="#regid#" />
				and survey_id = <cfqueryparam value="#surveyid#" />
		</cfquery>
	</cffunction>



</cfcomponent>
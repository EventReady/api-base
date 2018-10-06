<cfcomponent>
	<cffunction name="search" access="public" output="no">
		<cfargument name="clientId" required="yes" />		
		<cfargument name="eventId" required="yes" />		
		<cfargument name="term" required="yes" />		
		<cfargument  name="formatted_days" required="yes">
		<cfquery name="attendees" dataSource="#request.dsn#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
			WITH Attendees AS(
				SELECT r.first_name, r.last_name, r.email, r.first_name + ' ' + r.last_name as fullname, r.reg_id,
				ROW_NUMBER() OVER (ORDER BY last_name) AS 'RowNumber'
				FROM dbo.XR_Reg_Events as x
				inner join dbo.registrations as r on r.reg_ID = x.reg_id
				where event_id = <cfqueryparam value="#arguments.eventId#" />
			) 
			SELECT  top 15 * 
			FROM Attendees 
			where fullname like <cfqueryparam value="%#arguments.term#%" /> 
			order by last_name asc
		</cfquery>

		
		<cfquery name="exhibitors" dataSource="#request.dsn#" cachedWithin="#CreateTimeSpan(0, 1, 0, 0)#">
			SELECT  top 15  '' as booth_number, E.Exhibitor,E.Exhib_ID,EE.Exhib_Status,E.create_date,EE.has_Lockout,EE.has_Format,EE.has_Login,EE.Contract_Status,
			EE.Total_Badges,EE.LoginSend_Date,EE.Booth_Selection_Notes,EE.logo_file, LEN(cast(EE.Description as varchar(1000))) AS Desc_Len,EE.event_exhib_id, 
			LEN(cast(EE.Comments as varchar(1000))) AS Comment_Len, 
			(SELECT TOP 1 Email FROM Exhib_Contacts WHERE Exhib_ID = E.Exhib_ID) AS Contact_Email
			FROM Exhibitors E INNER JOIN XR_Event_Exhibs EE ON E.Exhib_ID = EE.Exhib_ID 
			WHERE EE.Exhib_ID = EE.ExhibAs_ID AND EE.Event_ID = <cfqueryparam value="#eventId#" />  
			AND EE.Exhib_Status = 'Active' 
			and e.exhibitor like <cfqueryparam value="%#arguments.term#%" /> 
			ORDER BY E.Exhibitor
		</cfquery>
		<Cfset FN = new FNs() />
		<cfquery name="scheduleList" dataSource="#request.dsn#" cachedWithin="#CreateTimeSpan(0, 1, 0, 0)#">
			WITH list AS(
				select *, 
				ROW_NUMBER() OVER (ORDER BY session_name) AS 'RowNumber'
				from dbo.Loc_Sessions 
				where start_date = <cfqueryparam value="#formatted_days[1]#" />
				OR start_date = <cfqueryparam value="#formatted_days[2]#" />
			) 
			SELECT top 15 *, 1 as session, 0 as agenda, 0 as activity
			FROM list
			where session_name like <cfqueryparam value="%#arguments.term#%" /> 
			order by start_date asc, start_time asc
		</cfquery>

		<cfquery name="speakers" dataSource="#request.dsn#" cachedWithin="#CreateTimeSpan(0, 1, 0, 0)#">
			select top 15 t1.speaker_id,t1.Work_Phone,t1.Create_Date,t1.photo_file,t1.bio_file, t1.First_Name,t1.Last_Name,t1.Email,t1.Title,t1.Company,t1.Address,t1.City,t1.State,t1.Zip,t1.Bio 
			from Loc_Speakers t1 
			where event_id = <cfqueryparam value="#arguments.eventId#" />
			
			and ( t1.first_name like <cfqueryparam value="%#arguments.term#%" /> 
			or t1.last_name like <cfqueryparam value="%#arguments.term#%" /> )

			ORDER BY t1.last_name ASC		
		</cfquery>

		<cfquery name="sponsors" dataSource="#request.dsn#" cachedWithin="#CreateTimeSpan(0, 1, 0, 0)#">
			SELECT top 15  *
			FROM app_sponsors
			WHERE event_id = <cfqueryparam value="#eventId#" /> 
			and active = 1
			and name like <cfqueryparam value="%#arguments.term#%" />  
			order by name
		</cfquery>


		<Cfreturn {
			'attendees' : attendees,
			'exhibitors' : exhibitors,
			"schedule" : scheduleList,
			"speakers" : speakers,
			"sponsors" : sponsors
		} />
	</cffunction>




</cfcomponent>
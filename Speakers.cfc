<cfcomponent>
	<cffunction name="getSpeaker" access="public" output="no">
		<cfargument name="speakerId" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#">
			select * from dbo.loc_speakers
			where speaker_id = <cfqueryparam value="#speakerId#" />
			order by last_name			
		</cfquery>
		<Cfreturn q />
	</cffunction>
	<cffunction name="getSpeakerSessions" access="public" output="no">
		<cfargument name="speakerId" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#">
			select distinct s.session_id, s.session_name, s.start_date, s.start_time, s.end_time, s.room
			FROM Loc_Sessions S 
			left JOIN Loc_Tracks t3 ON S.Track_ID = t3.Track_ID 
			left join Loc_Speaker_Pres as t2 on t2.track_id = t3.track_id
			left join Loc_Speakers as t1 on t1.speaker_id = t2.speaker_id
			where s.speaker_id = <cfqueryparam value="#speakerId#" /> --and t2.status = 'accepted'
			order by s.start_date asc		
		</cfquery>
		<Cfreturn q />	
	</cffunction>
	<cffunction name="getSpeakers" access="public" output="no">
		<cfargument name="eventid" required="yes" />				
		<cfquery name="q" dataSource="#request.dsn#">
			select t1.speaker_id,t1.Work_Phone,t1.Create_Date,t1.photo_file,t1.bio_file, t1.First_Name,t1.Last_Name,t1.Email,t1.Title,t1.Company,t1.Address,t1.City,t1.State,t1.Zip,t1.Bio 
			from Loc_Speakers t1 
			where 1=1 
			and t1.first_name is not null and t1.last_name is not null
			and t1.event_id = <cfqueryparam value="#eventid#" />
			ORDER BY t1.last_name ASC		
		</cfquery>
		<Cfreturn q />
	</cffunction>

</cfcomponent>
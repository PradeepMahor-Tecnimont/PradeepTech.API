namespace RapReportingApi.Repositories.Interfaces
{
    public interface IBeforePostCCRepository
    {
        object AuditorReport(string yymm, string yearmode, string activeyear);

        //Monthly Jobwise Manhours
        object MJMReport(string yymm, string costcode);

        //Monthly Jobwise Activity Manhours
        object MJAMReport(string yymm, string costcode);

        //Manhours of costcentre - STA6
        object DUPLSTA6Report(string yymm, string costcode);

        object MJEAMReport(string yymm, string costcode);

        //Timesheet Status
        object CCPOSTDETReport(string costcode);

        //Monthly Hours Exceeding 240 hrs
        object MHrsExceedReport(string yymm, string costcode);

        //Leave / Vacation / Illness
        object LeaveReport(string yymm, string costcode);

        //Odd Timesheet
        object OddTimesheetReport(string yymm, string costcode);

        //Not Posted Timesheet
        object NotPostedTimesheetReport(string yymm, string costcode);

        object MJM_All_RptDownload(string yymm, string costcode);
    }
}
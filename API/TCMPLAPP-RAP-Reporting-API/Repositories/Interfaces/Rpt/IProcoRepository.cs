namespace RapReportingApi.Repositories.Interfaces
{
    public interface IProcoRepository
    {
        //cc_post - PROCO
        object cc_post();

        object DATEWISE_TS(string ProjNo, string Yymm);

        object TS_ACT_COVID(string Yymm);

        //check_posted - PROCO
        object check_posted();

        //exptjobs - PROCO
        object exptjobs();

        //kallo_daily - PROCO
        object kallo_daily(string yymm);

        //projections - PROCO
        object projections(string yymm);

        public object PROCO_TS_ACT(string yymm);

        public object PlanRep4(string yymm);

        public object PlanRep5(string yymm);

        //Employees / Manhours who have not posted their Timesheets
        object empl_mhrs_not_posted(string yymm);
    }
}
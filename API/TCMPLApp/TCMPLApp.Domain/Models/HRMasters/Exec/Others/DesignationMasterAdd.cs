namespace TCMPLApp.Domain.Models.HRMasters
{
    public class DesignationMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.DesignationMasterAdd; }
        public string PDesgcode { get; set; }
        public string PDesg { get; set; }
        public string PDesgNew { get; set; }
        public string POrd { get; set; }
        public string PSubcode { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
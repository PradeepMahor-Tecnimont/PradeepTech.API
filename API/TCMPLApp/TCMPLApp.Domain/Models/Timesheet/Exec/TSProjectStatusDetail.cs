using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class TSProjectStatusDetail : DBProcMessageOutput
    {        
        public decimal? PSubmit { get; set; }        
        public decimal? PFilled { get; set; }
        public decimal? PFilledNhr { get; set; }
        public decimal? PFilledOhr { get; set; }
        public decimal? PFilledThr { get; set; }
        public decimal? PLocked { get; set; }        
        public decimal? PLockedNhr { get; set; }       
        public decimal? PLockedOhr { get; set; }      
        public decimal? PLockedThr { get; set; }        
        public decimal? PApproved { get; set; }       
        public decimal? PApprovedNhr { get; set; }        
        public decimal? PApprovedOhr { get; set; }        
        public decimal? PApprovedThr { get; set; }        
        public decimal? PPosted { get; set; }       
        public decimal? PPostedNhr { get; set; }      
        public decimal? PPostedOhr { get; set; }        
        public decimal? PPostedThr { get; set; }

    }
}

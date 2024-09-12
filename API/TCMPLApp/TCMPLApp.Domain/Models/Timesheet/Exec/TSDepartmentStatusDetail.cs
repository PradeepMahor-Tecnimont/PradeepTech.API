using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class TSDepartmentStatusDetail : DBProcMessageOutput
    {
        public decimal? PWrkHours { get; set; }
        public string PProcessMonth { get; set; }
        public decimal? PSubmitCount { get; set; }
        public decimal? POddCount { get; set; }
        public decimal? POutsourceCount { get; set; }
        public decimal? PTotalCount { get; set; }
        public decimal? PFilled { get; set; }
        public decimal? PFilledNhr { get; set; }
        public decimal? PFilledOhr { get; set; }
        public decimal? PFilledOuthr { get; set; }
        public decimal? PFilledThr { get; set; }
        public decimal? PLocked { get; set; }        
        public decimal? PLockedNhr { get; set; }       
        public decimal? PLockedOhr { get; set; }
        public decimal? PLockedOuthr { get; set; }
        public decimal? PLockedThr { get; set; }        
        public decimal? PApproved { get; set; }       
        public decimal? PApprovedNhr { get; set; }        
        public decimal? PApprovedOhr { get; set; }
        public decimal? PApprovedOuthr { get; set; }
        public decimal? PApprovedThr { get; set; }        
        public decimal? PPosted { get; set; }       
        public decimal? PPostedNhr { get; set; }      
        public decimal? PPostedOhr { get; set; }
        public decimal? PPostedOuthr { get; set; }
        public decimal? PPostedThr { get; set; }

    }
}

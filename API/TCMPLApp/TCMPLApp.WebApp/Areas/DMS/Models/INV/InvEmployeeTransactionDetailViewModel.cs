using System;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class InvEmployeeTransactionDetailViewModel : Domain.Models.DMS.InvEmployeeTransactionDetailDataTableList
    {
        public InvEmployeeTransactionDetailViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public string Empno { get; set; }
        public string TransTypeId { get; set; }
        //public string ItemUsable { get; set; }

        public DateTime? TransDate { get; set; }
        public string Remarks { get; set; }

        public InvEmployeeDetails InvEmployeeDetails { get; set; }
    }
}
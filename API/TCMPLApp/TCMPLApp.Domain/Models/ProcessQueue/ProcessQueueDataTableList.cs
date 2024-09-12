using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.ProcessQueue
{
    public class ProcessQueueDataTableList
    {
        [Display(Name = "Key")]
        public string KeyId { get; set; }

        [Display(Name = "Module id")]
        public string ModuleId { get; set; }

        [Display(Name = "Process id")]
        public string ProcessId { get; set; }

        [Display(Name = "Process description")]
        public string ProcessDesc { get; set; }

        [Display(Name = "Process item id")]
        public string ProcessItemId { get; set; }

        [Display(Name = "Parameter json")]
        public string ParameterJson { get; set; }

        [Display(Name = "Process start date")]
        public DateTime? ProcessStartDate { get; set; }

        [Display(Name = "Process finish date")]
        public DateTime? ProcessFinishDate { get; set; }

        [Display(Name = "Created on")]
        public DateTime? CreatedOn { get; set; }

        [Display(Name = "Status")]
        public short Status { get; set; }

        [Display(Name = "Status description")]
        public string StatusDesc { get; set; }

        [Display(Name = "Process log")]
        public string ProcessLog { get; set; }
    }
}
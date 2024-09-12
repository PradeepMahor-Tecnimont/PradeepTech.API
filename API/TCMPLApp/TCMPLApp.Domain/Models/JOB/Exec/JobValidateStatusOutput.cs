using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobValidateStatusOutput : DBProcMessageOutput
    {        
        public string PDescNotesType { get; set; }        
        public string PDescNotesText { get; set; }        
        public string PJobPhasesType { get; set; }        
        public string PJobPhasesText { get; set; }        
        public string PResponsibleRolesType { get; set; }        
        public string PResponsibleRolesText { get; set; }        
        public string PBudgetType { get; set; }        
        public string PBudgetText { get; set; }        
        public string PErpPhasesType { get; set; }        
        public string PErpPhasesText { get; set; }        
    }
}

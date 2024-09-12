using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    [Serializable]
    public class FilterModel
    {
        public string ControllerName { get; set; }

        public FilterDataModel FilterDataModel { get; set; }
    }    
}

using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.WebApp.Models
{
    public partial class SwpVuEmpResponseModel
    {
        public IEnumerable<SelectListItem> HodfilterList { get; set; }
        public IEnumerable<SelectListItem> HRfilterList { get; set; }
        public IEnumerable<SelectListItem> DeptList { get; set; }
        public IEnumerable<SwpVuEmpResponse> SwpVuEmpResponseList { get; set; }
    }
}
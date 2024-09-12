using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLAPP.WinService.Models
{  
    public class ProjectModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public ProjectData Data { get; set; }
    }

    public class ProjectData
    {
        public List<Project> value { get; set; }
        public string[] formatters { get; set; }
        public string[] contentTypes { get; set; }
        public string declaredType { get; set; }
        public short? statusCode { get; set; }
    }

    public class Project
    {
        public string projno { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.Models.User
{
    public class rap_user_config
    {
        [Key]
        public string UniversalProcessingMonth { get; set; }

        //public string PreferredRole { get; set; }
        public virtual List<rap_user_config_role_record> Roles { get; set; }
    }

    public partial class rap_user_config_role_dept_record
    {
        public string Costcode { get; set; }
        public string Name { get; set; }
        public string Abbr { get; set; }
        public short Active { get; set; }
    }

    public partial class rap_user_config_role_proj_record
    {
        public string Project { get; set; }
        public string Name { get; set; }
        public bool? Active { get; set; }
        public DateTime? Sdate { get; set; }
        public DateTime? Revcdate { get; set; }
    }

    public class rap_user_config_role_record
    {
        public string Role { get; set; }
        public string Name { get; set; }
        public virtual List<rap_user_config_role_dept_record> Costcodes { get; set; }
        public virtual List<rap_user_config_role_proj_record> Projects { get; set; }
        public int[] Action { get; set; }
    }

    public partial class LoggedIn
    {
        [Key]
        public string Empno { get; set; }

        public string Name { get; set; }
    }
}
using System;

namespace TCMPLApp.DataAccess.Models
{
    public class BaseSpTcmPL
    {
        public Guid? UIUserId { get; set; }

        public string PPersonId { get; set; }
        public string PMetaId { get; set; }
    }
}

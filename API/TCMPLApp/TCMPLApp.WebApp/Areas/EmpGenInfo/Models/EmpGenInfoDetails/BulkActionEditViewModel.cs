using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace TCMPLApp.WebApp.Models
{
    public class BulkActionEditViewModel
    {
        public string LockPrimary { get; set; }
        public string LockSecondary{ get; set; }

        public string LockNomination { get; set; }

        public string LockMediclaim { get; set; }

        public string LockAdhaar { get; set; }

        public string LockPassport { get; set; }

        public string LockGTLI { get; set; }

        public string OpenPrimary { get; set; }
        public string OpenSecondary{ get; set; }

        public string OpenNomination { get; set; }

        public string OpenMediclaim { get; set; }

        public string OpenAadhaar { get; set; }

        public string OpenPassport { get; set; }

        public string OpenGtli { get; set; }

    }
}

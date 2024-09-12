using System.Collections.Generic;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.WebApp.Models
{
    public class JobNotesDetailViewModel : JobNotesDetail
    {
        public IEnumerable<ProfileAction> ProjectActions { get; set; }

    }
}

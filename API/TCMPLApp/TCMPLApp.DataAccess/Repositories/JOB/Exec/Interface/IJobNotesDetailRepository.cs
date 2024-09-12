﻿using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public interface IJobNotesDetailRepository
    {
        
        public Task<JobNotesDetail> NotesDetailAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

       
    }
}

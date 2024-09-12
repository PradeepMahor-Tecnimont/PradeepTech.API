using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DigiForm;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public interface IMidEvaluationGetKeyIdRepository
    {
        public Task<MidEvaluationGetKeyId> MidEvaluationGetKeyId(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}

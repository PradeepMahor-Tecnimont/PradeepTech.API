using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DigiForm;
using TCMPLApp.Domain.Models.OffBoarding;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public interface IMidEvaluationDetailRepository
    {
        public Task<MidEvaluationDetail> MidEvaluationDetails(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}

using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DigiForm;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public interface IAnnualEvaluationGetKeyIdRepository
    {
        public Task<AnnualEvaluationGetKeyId> AnnualEvaluationGetKeyId(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}

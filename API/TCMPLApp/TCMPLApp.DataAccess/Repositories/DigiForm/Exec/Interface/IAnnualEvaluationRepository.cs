using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public interface IAnnualEvaluationRepository
    {
        public Task<DBProcMessageOutput> AnnualEvaluationEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
                                         
        public Task<DBProcMessageOutput> AnnualEvaluationUpdateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
                                         
        public Task<DBProcMessageOutput> AnnualEvaluationSendToHRAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
                                         
        public Task<DBProcMessageOutput> AnnualEvaluationSendToHODAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
                                         
        public Task<DBProcMessageOutput> AnnualEvaluationValidateEmployeeAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> AnnualEvaluationSaveHrCommentAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}

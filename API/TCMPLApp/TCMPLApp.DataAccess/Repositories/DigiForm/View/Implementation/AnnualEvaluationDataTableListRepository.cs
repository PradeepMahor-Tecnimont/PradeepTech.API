using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DigiForm;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public class AnnualEvaluationDataTableListRepository : ViewTcmPLRepository<AnnualEvaluationDataTableList>, IAnnualEvaluationDataTableListRepository
    {
        public AnnualEvaluationDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<AnnualEvaluationDataTableList>> HRAnnualEvaluationPendingDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_annu_evaluation_qry.fn_dg_annu_evaluation_hr_pending_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<AnnualEvaluationDataTableList>> HRAnnualEvaluationPendingDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_annu_evaluation_qry.fn_dg_annu_evaluation_hr_pending_list_xl";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<AnnualEvaluationDataTableList>> HRAnnualEvaluationActionPendingDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_annu_evaluation_qry.fn_dg_annu_hr_action_pending_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<AnnualEvaluationDataTableList>> HODAnnualEvaluationPendingDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_annu_evaluation_qry.fn_dg_annu_evaluation_hod_pending_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<AnnualEvaluationDataTableList>> HRAnnualEvaluationHistoryDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_annu_evaluation_qry.fn_dg_annu_evaluation_hr_history_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<AnnualEvaluationDataTableList>> HODAnnualEvaluationHistoryDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_annu_evaluation_qry.fn_dg_annu_evaluation_hod_history_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}

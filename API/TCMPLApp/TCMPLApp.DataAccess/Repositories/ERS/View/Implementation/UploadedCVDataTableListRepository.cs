using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.ERS;

namespace TCMPLApp.DataAccess.Repositories.ERS
{
    public class UploadedCVDataTableListRepository : ViewTcmPLRepository<UploadedCVDataTableList>, IUploadedCVDataTableListRepository
    {

        public UploadedCVDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<UploadedCVDataTableList>> UploadedCVDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {

            CommandText = "tcmpl_hr.ers_qry.fn_ers_uploaded_cv_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);                   
        }        
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Models.SWPVaccine;


namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class UploadExcelBLobRepository : DataAccess.Base.ExecRepository, IUploadExcelBLobRepository
    {
        public UploadExcelBLobRepository(TCMPLApp.Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {
        }

        public async Task<UploadExcelFileToDb> UploadSchedule(UploadExcelFileToDb uploadExcelFileToDb)
        {
            return await ExecuteProcUsingODPNetAsync(uploadExcelFileToDb);
            //return await ExecuteProcAsync(uploadExcelFileToDb);
        }
    }
}

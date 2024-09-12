using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.RapReporting;
using TCMPLApp.Domain.Models.SelfService;

namespace TCMPLApp.DataAccess.Repositories.Common
{
    public class SelectRepository : Base.ExecRepository, ISelectRepository
    {
        //private readonly IHRMastersRepository _hrmastersRepository;

        public SelectRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        public async Task<IEnumerable<DataField>> EmployeeSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.EmployeeSelectList);
        }

        public async Task<IEnumerable<DataField>> CostcenterSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.CostcenterSelectList);            
        }

        public async Task<IEnumerable<DataField>> CostcenterWithEmployeeSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.CostcenterWithEmployeeSelectList);
        }

        public async Task<IEnumerable<DataField>> CostcenterIdSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.CostcenterIdSelectList);
        }

        public async Task<IEnumerable<DataField>>DesignationSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.DesignationSelectList);
        }

        public async Task<IEnumerable<DataField>> GradeSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.GradeSelectList);
        }

        public async Task<IEnumerable<DataField>> OfficeSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.OfficeSelectList);
        }

        public async Task<IEnumerable<DataField>> EmptypeSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.EmptypeSelectList);
        }

        public async Task<IEnumerable<DataField>> CategorySelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.CategorySelectList);
        }

        public async Task<IEnumerable<DataField>> GenderSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.GenderSelectList);
        }

        public async Task<IEnumerable<DataField>> CompanySelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.CompanySelectList);
        }

        public async Task<IEnumerable<DataField>> CostGroupSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.CostGroupSelectList);
        }

        public async Task<IEnumerable<DataField>> TM01GRPSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.TM01GRPSelectList);
        }

        public async Task<IEnumerable<DataField>> TMAGRPSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.TMAGRPSelectList);
        }

        public async Task<IEnumerable<DataField>> CostTypeSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.CostTypeSelectList);
        }

        public async Task<IEnumerable<DataField>> CompanyReportSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.CompanyReportSelectList);
        }

        public async Task<IEnumerable<DataField>> TCMCostCenterSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.TCMCostCenterSelectList);
        }

        public async Task<IEnumerable<DataField>> TCMActPhSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.TCMActPhSelectList);
        }

        public async Task<IEnumerable<DataField>> TCMPasPhSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.TCMPasPhSelectList);
        }

        public async Task<IEnumerable<DataField>> JobPhasesSelectListCacheAsync(string cmid)
        {
            return await QueryAsync<DataField>(HRMastersQueries.JobPhasesSelectList, new { pCmId = cmid });
        }

        public async Task<IEnumerable<DataField>> LocationSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.LocationSelectList);
        }

        public async Task<IEnumerable<DataField>> SubContractSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.SubContractSelectList);
        }

        public async Task<IEnumerable<DataField>> BankcodeSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.BankcodeSelectList);
        }
        
        public async Task<IEnumerable<DataField>> LeaveTypeListCacheAsync()
        {
            return await QueryAsync<DataField>(SelfServiceQueries.LeaveTypeSelectList);
        }
        
        public async Task<IEnumerable<DataField>> ApproversListCacheAsync()
        {
            return await QueryAsync<DataField>(SelfServiceQueries.ApproverSelectList);
        }

        public async Task<IEnumerable<DataField>> LeavingReasonSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.LeavingReasonSelectList);
        }

        public async Task<IEnumerable<DataField>> PlaceSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.PlaceSelectList);
        }

        public async Task<IEnumerable<DataField>> GraduationSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.GraduationSelectList);
        }

        public async Task<IEnumerable<DataField>> QualificationSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.QualificationSelectList);
        }

        public async Task<IEnumerable<DataField>> JobGroupSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.JobGroupSelectList);
        }

        public async Task<IEnumerable<DataField>> JobGroupJobDisciplineSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.JobGroupJobDisciplineSelectList);
        }

        public async Task<IEnumerable<DataField>> JobGroupJobDisciplineJobTitleSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.JobGroupJobDisciplineJobTitleSelectList);
        }

        public async Task<IEnumerable<DataField>> CostcenterEmployeeSelectListCacheAsync(string hod)
        {
            return await QueryAsync<DataField>(HRMastersQueries.CostcenterEmployeeSelectList, new { pHod = hod});
        }

        public async Task<IEnumerable<DataField>> SecretaryEmployeeSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.SecretaryEmployeeSelectList);
        }

        public async Task<IEnumerable<DataField>> CostGroupCostcenterIdSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.CostGroupCostcenterIdSelectList);
        }

        public async Task<IEnumerable<DataField>> ParentCostcenterCostcenterIdSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.ParentCostCenterCostcenterIdSelectList);
        }

        public async Task<IEnumerable<DataField>> HRJobgroupSelectListCacheAsync() 
        {
            return await QueryAsync<DataField>(HRMastersQueries.HRJobGroupSelectList);
        }

        public async Task<IEnumerable<DataField>> HRJobdisciplineSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.HRJobDisciplineSelectList);
        }

        public async Task<IEnumerable<DataField>> HRJobtitleSelectListCacheAsync()
        {
            return await QueryAsync<DataField>(HRMastersQueries.HRJobTitleSelectList);
        }
    }
}

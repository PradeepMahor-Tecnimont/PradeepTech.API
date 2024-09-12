using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class HRMastersViewRepository : Base.ExecRepository, IHRMastersViewRepository
    {
        public HRMastersViewRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {
        }

        #region >>>>>>>>>>> D E S I G N A T I O N   M A S T E R <<<<<<<<<<<<<<

        public async Task<int?> GetDesignationCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.DesignationMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<DesignationMaster>> GetDesignationMasterListAsync()
        {
            return await QueryAsync<DesignationMaster>(HRMastersQueries.DesignationMasterList);
        }

        public async Task<DesignationMaster> DesignationDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<DesignationMaster>(HRMastersQueries.DesignationMasterDetail, new { pDesgcode = id });
        }

        public async Task<IEnumerable<DesignationMasterDownload>> GetDesignationMasterDownload()
        {
            return await QueryAsync<DesignationMasterDownload>(HRMastersQueries.DesignationMasterDownload);
        }

        #endregion >>>>>>>>>>> D E S I G N A T I O N   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> B A N K C O D E   M A S T E R <<<<<<<<<<<<<<

        public async Task<int?> GetBankcodeCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.BankcodeMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<BankcodeMaster>> GetBankcodeMasterListAsync()
        {
            return await QueryAsync<BankcodeMaster>(HRMastersQueries.BankcodeMasterList);
        }

        public async Task<BankcodeMaster> BankcodeDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<BankcodeMaster>(HRMastersQueries.BankcodeMasterDetail, new { pBankcode = id });
        }

        #endregion >>>>>>>>>>> B A N K C O D E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> C A T E G O R Y   M A S T E R <<<<<<<<<<<<<<

        public async Task<int?> GetCategoryCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.CategoryMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<CategoryMaster>> GetCategoryMasterListAsync()
        {
            return await QueryAsync<CategoryMaster>(HRMastersQueries.CategoryMasterList);
        }

        public async Task<CategoryMaster> CategoryDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<CategoryMaster>(HRMastersQueries.CategoryMasterDetail, new { pCategoryid = id });
        }

        #endregion >>>>>>>>>>> C A T E G O R Y   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> E M P T Y P E   M A S T E R <<<<<<<<<<<<<<

        public async Task<int?> GetEmptypeCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.EmptypeMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<EmptypeMaster>> GetEmptypeMasterListAsync()
        {
            return await QueryAsync<EmptypeMaster>(HRMastersQueries.EmptypeMasterList);
        }

        public async Task<EmptypeMaster> EmptypeDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<EmptypeMaster>(HRMastersQueries.EmptypeMasterDetail, new { pEmptype = id });
        }

        #endregion >>>>>>>>>>> E M P T Y P E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> G R A D E   M A S T E R <<<<<<<<<<<<<<

        public async Task<int?> GetGradeCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.GradeMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<GradeMaster>> GetGradeMasterListAsync()
        {
            return await QueryAsync<GradeMaster>(HRMastersQueries.GradeMasterList);
        }

        public async Task<GradeMaster> GradeDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<GradeMaster>(HRMastersQueries.GradeMasterDetail, new { pGradeid = id });
        }

        public async Task<IEnumerable<GradeMasterDownload>> GetGradeMasterDownload()
        {
            return await QueryAsync<GradeMasterDownload>(HRMastersQueries.GradeMasterDownload);
        }

        #endregion >>>>>>>>>>> G R A D E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> L O C A T I O N   M A S T E R <<<<<<<<<<<<<<

        public async Task<int?> GetLocationCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.LocationMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<LocationMaster>> GetLocationMasterListAsync()
        {
            return await QueryAsync<LocationMaster>(HRMastersQueries.LocationMasterList);
        }

        public async Task<LocationMaster> LocationDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<LocationMaster>(HRMastersQueries.LocationMasterDetail, new { pLocationid = id });
        }

        #endregion >>>>>>>>>>> L O C A T I O N   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> O F F I C E   M A S T E R <<<<<<<<<<<<<<

        public async Task<int?> GetOfficeCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.OfficeMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<OfficeMaster>> GetOfficeMasterListAsync()
        {
            return await QueryAsync<OfficeMaster>(HRMastersQueries.OfficeMasterList);
        }

        public async Task<OfficeMaster> OfficeDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<OfficeMaster>(HRMastersQueries.OfficeMasterDetail, new { pOffice = id });
        }

        #endregion >>>>>>>>>>> O F F I C E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> S U B C O N T R A C T   M A S T E R <<<<<<<<<<<<<<

        public async Task<int?> GetSubcontractCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.SubcontractMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<SubcontractMaster>> GetSubcontractMasterListAsync()
        {
            return await QueryAsync<SubcontractMaster>(HRMastersQueries.SubcontractMasterList);
        }

        public async Task<SubcontractMaster> SubcontractDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<SubcontractMaster>(HRMastersQueries.SubcontractMasterDetail, new { pSubcontract = id });
        }

        public async Task<IEnumerable<SubcontractMasterDownload>> GetSubcontractMasterDownload()
        {
            return await QueryAsync<SubcontractMasterDownload>(HRMastersQueries.SubcontractMasterDownload);
        }

        #endregion >>>>>>>>>>> S U B C O N T R A C T   M A S T E R <<<<<<<<<<<<<<

        #region Place master

        public async Task<int?> GetPlaceCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.PlaceMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<PlaceMaster>> GetPlaceMasterListAsync()
        {
            return await QueryAsync<PlaceMaster>(HRMastersQueries.PlaceMasterList);
        }

        public async Task<PlaceMaster> PlaceDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<PlaceMaster>(HRMastersQueries.PlaceMasterDetail, new { pPlaceid = id });
        }

        #endregion Place master

        #region Qualification master

        public async Task<int?> GetQualificationCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.QualificationMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<QualificationMaster>> GetQualificationMasterListAsync()
        {
            return await QueryAsync<QualificationMaster>(HRMastersQueries.QualificationMasterList);
        }

        public async Task<QualificationMaster> QualificationDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<QualificationMaster>(HRMastersQueries.QualificationMasterDetail, new { pQualificationid = id });
        }

        public async Task<IEnumerable<QualificationMasterDownload>> GetQualificationMasterDownload()
        {
            return await QueryAsync<QualificationMasterDownload>(HRMastersQueries.QualificationMasterDownload);
        }

        #endregion Qualification master

        #region Graduation master

        public async Task<int?> GetGraduationCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.GraduationMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<GraduationMaster>> GetGraduationMasterListAsync()
        {
            return await QueryAsync<GraduationMaster>(HRMastersQueries.GraduationMasterList);
        }

        public async Task<GraduationMaster> GraduationDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<GraduationMaster>(HRMastersQueries.GraduationMasterDetail, new { pGraduationid = id });
        }

        public async Task<IEnumerable<GraduationMasterDownload>> GetGraduationMasterDownload()
        {
            return await QueryAsync<GraduationMasterDownload>(HRMastersQueries.GraduationMasterDownload);
        }

        #endregion Graduation master

        #region Job Group master

        public async Task<int?> GetJobGroupCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.JobGroupMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<JobGroupMaster>> GetJobGroupMasterListAsync()
        {
            return await QueryAsync<JobGroupMaster>(HRMastersQueries.JobGroupMasterList);
        }

        public async Task<JobGroupMaster> JobGroupDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<JobGroupMaster>(HRMastersQueries.JobGroupMasterDetail, new { pGrpCd = id });
        }

        public async Task<IEnumerable<JobGroupMasterDownload>> GetJobGroupMasterDownload()
        {
            return await QueryAsync<JobGroupMasterDownload>(HRMastersQueries.JobGroupMasterDownload);
        }

        #endregion Job Group master

        #region Job Discipline master

        public async Task<int?> GetJobDisciplineCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.JobDisciplineMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<JobDisciplineMaster>> GetJobDisciplineMasterListAsync()
        {
            return await QueryAsync<JobDisciplineMaster>(HRMastersQueries.JobDisciplineMasterList);
        }

        public async Task<JobDisciplineMaster> JobDisciplineDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<JobDisciplineMaster>(HRMastersQueries.JobDisciplineMasterDetail, new { pDisCd = id });
        }

        public async Task<IEnumerable<JobDisciplineMasterDownload>> GetJobDisciplineMasterDownload()
        {
            return await QueryAsync<JobDisciplineMasterDownload>(HRMastersQueries.JobDisciplineMasterDownload);
        }

        #endregion Job Discipline master

        #region Job Title master

        public async Task<int?> GetJobTitleCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.JobTitleMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<JobTitleMaster>> GetJobTitleMasterListAsync()
        {
            return await QueryAsync<JobTitleMaster>(HRMastersQueries.JobTitleMasterList);
        }

        public async Task<JobTitleMaster> JobTitleDetail(string id)
        {
            return await QueryFirstOrDefaultAsync<JobTitleMaster>(HRMastersQueries.JobTitleMasterDetail, new { pTitCd = id });
        }

        public async Task<IEnumerable<JobTitleMasterDownload>> GetJobTitleMasterDownload()
        {
            return await QueryAsync<JobTitleMasterDownload>(HRMastersQueries.JobTitleMasterDownload);
        }

        #endregion Job Title master
    }
}
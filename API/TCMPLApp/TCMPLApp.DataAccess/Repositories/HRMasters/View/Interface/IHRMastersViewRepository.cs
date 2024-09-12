using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IHRMastersViewRepository
    {
        #region >>>>>>>>>>> D E S G I N A T I O N   M A S T E R <<<<<<<<<<<<<<

        public Task<int?> GetDesignationCount();

        public Task<IEnumerable<DesignationMaster>> GetDesignationMasterListAsync();

        public Task<DesignationMaster> DesignationDetail(string id);

        public Task<IEnumerable<DesignationMasterDownload>> GetDesignationMasterDownload();

        #endregion

        #region >>>>>>>>>>> B A N K C O D E   M A S T E R <<<<<<<<<<<<<< 

        public Task<int?> GetBankcodeCount();

        public Task<IEnumerable<BankcodeMaster>> GetBankcodeMasterListAsync();

        public Task<BankcodeMaster> BankcodeDetail(string id);

        #endregion

        #region >>>>>>>>>>> C A T E G O R Y   M A S T E R <<<<<<<<<<<<<<

        public Task<int?> GetCategoryCount();

        public Task<IEnumerable<CategoryMaster>> GetCategoryMasterListAsync();

        public Task<CategoryMaster> CategoryDetail(string id);

        #endregion

        #region >>>>>>>>>>> E M P T Y P E   M A S T E R <<<<<<<<<<<<<< 

        public Task<int?> GetEmptypeCount();

        public Task<IEnumerable<EmptypeMaster>> GetEmptypeMasterListAsync();

        public Task<EmptypeMaster> EmptypeDetail(string id);

        #endregion

        #region >>>>>>>>>>> G R A D E   M A S T E R <<<<<<<<<<<<<<

        public Task<int?> GetGradeCount();

        public Task<IEnumerable<GradeMaster>> GetGradeMasterListAsync();

        public Task<GradeMaster> GradeDetail(string id);

        public Task<IEnumerable<GradeMasterDownload>> GetGradeMasterDownload();

        #endregion

        #region >>>>>>>>>>> L O C A T I O N   M A S T E R <<<<<<<<<<<<<<

        public Task<int?> GetLocationCount();

        public Task<IEnumerable<LocationMaster>> GetLocationMasterListAsync();

        public Task<LocationMaster> LocationDetail(string id);

        #endregion

        #region >>>>>>>>>>> O F F I C E   M A S T E R <<<<<<<<<<<<<<

        public Task<int?> GetOfficeCount();

        public Task<IEnumerable<OfficeMaster>> GetOfficeMasterListAsync();

        public Task<OfficeMaster> OfficeDetail(string id);

        #endregion

        #region >>>>>>>>>>> S U B C O N T R A C T   M A S T E R <<<<<<<<<<<<<<

        public Task<int?> GetSubcontractCount();

        public Task<IEnumerable<SubcontractMaster>> GetSubcontractMasterListAsync();

        public Task<SubcontractMaster> SubcontractDetail(string id);

        public Task<IEnumerable<SubcontractMasterDownload>> GetSubcontractMasterDownload();
        
        #endregion

        #region Place master
        public Task<int?> GetPlaceCount();

        public Task<IEnumerable<PlaceMaster>> GetPlaceMasterListAsync();

        public Task<PlaceMaster> PlaceDetail(string id);

        #endregion

        #region Qualification master
        public Task<int?> GetQualificationCount();

        public Task<IEnumerable<QualificationMaster>> GetQualificationMasterListAsync();

        public Task<QualificationMaster> QualificationDetail(string id);

        public Task<IEnumerable<QualificationMasterDownload>> GetQualificationMasterDownload();

        #endregion

        #region Graduation master
        public Task<int?> GetGraduationCount();

        public Task<IEnumerable<GraduationMaster>> GetGraduationMasterListAsync();

        public Task<GraduationMaster> GraduationDetail(string id);

        public Task<IEnumerable<GraduationMasterDownload>> GetGraduationMasterDownload();

        #endregion

        #region Job Group master
        public Task<int?> GetJobGroupCount();

        public Task<IEnumerable<JobGroupMaster>> GetJobGroupMasterListAsync();

        public Task<JobGroupMaster> JobGroupDetail(string id);

        public Task<IEnumerable<JobGroupMasterDownload>> GetJobGroupMasterDownload();

        #endregion

        #region Job Discipline master
        public Task<int?> GetJobDisciplineCount();

        public Task<IEnumerable<JobDisciplineMaster>> GetJobDisciplineMasterListAsync();

        public Task<JobDisciplineMaster> JobDisciplineDetail(string id);

        public Task<IEnumerable<JobDisciplineMasterDownload>> GetJobDisciplineMasterDownload();

        #endregion

        #region Job Title master
        public Task<int?> GetJobTitleCount();

        public Task<IEnumerable<JobTitleMaster>> GetJobTitleMasterListAsync();

        public Task<JobTitleMaster> JobTitleDetail(string id);

        public Task<IEnumerable<JobTitleMasterDownload>> GetJobTitleMasterDownload();

        #endregion
    }
}

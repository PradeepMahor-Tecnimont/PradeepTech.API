using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace TCMPLApp.WebApp.Classes
{
    public class DTModel
    {
        /// <summary>
        /// jQuery DataTables.
        /// </summary>
        /// <typeparam name="T">The data type of each row.</typeparam>
        public class DTResult<T>
        {
            /// <summary>
            /// The draw counter that this object is a response to - from the draw parameter sent as
            /// part of the data request. Note that it is strongly recommended for security reasons
            /// that you cast this parameter to an integer, rather than simply echoing back to the
            /// client what it sent in the draw parameter, in order to prevent Cross Site Scripting
            /// (XSS) attacks.
            /// </summary>
            public int draw { get; set; }

            /// <summary>
            /// Total records, before filtering (i.e. the total number of records in the database)
            /// </summary>
            public int recordsTotal { get; set; }

            /// <summary>
            /// Total records, after filtering (i.e. the total number of records after filtering has
            /// been applied - not just the number of records being returned for this page of data).
            /// </summary>
            public int recordsFiltered { get; set; }

            /// <summary>
            /// The data to be displayed in the table. This is an array of data source objects, one
            /// for each row, which will be used by DataTables. Note that this parameter's name can
            /// be changed using the ajaxDT option's dataSrc property.
            /// </summary>
            public List<T> data { get; set; }
        }

        /// <summary>
        /// The additional columns that you can send to jQuery DataTables for automatic processing.
        /// </summary>
        public abstract class DTRow
        {
            /// <summary>
            /// Set the ID property of the dt-tag tr node to this value
            /// </summary>
            public virtual string DT_RowId
            {
                get { return null; }
            }

            /// <summary>
            /// Add this class to the dt-tag tr node
            /// </summary>
            public virtual string DT_RowClass
            {
                get { return null; }
            }

            /// <summary>
            /// Add this data property to the row's dt-tag tr node allowing abstract data to be
            /// added to the node, using the HTML5 data-* attributes. This uses the jQuery data()
            /// method to set the data, which can also then be used for later retrieval (for example
            /// on a click event).
            /// </summary>
            public virtual object DT_RowData
            {
                get { return null; }
            }
        }

        /// <summary>
        /// The parameters sent by jQuery DataTables in AJAX queries.
        /// </summary>
        public class DTParameters
        {
            /// <summary>
            /// Draw counter. This is used by DataTables to ensure that the Ajax returns from
            /// server-side processing requests are drawn in sequence by DataTables (Ajax requests
            /// are asynchronous and thus can return out of sequence). This is used as part of the
            /// draw return parameter (see below).
            /// </summary>
            [JsonPropertyName("draw")]
            public int Draw { get; set; }

            /// <summary>
            /// An array defining all columns in the table.
            /// </summary>
            public DTColumn[] Columns { get; set; }

            /// <summary>
            /// An array defining how many columns are being ordering upon - i.e. if the array
            /// length is 1, then a single column sort is being performed, otherwise a multi-column
            /// sort is being performed.
            /// </summary>
            public DTOrder[] Order { get; set; }

            /// <summary>
            /// Paging first record indicator. This is the start point in the current data set (0
            /// index based - i.e. 0 is the first record).
            /// </summary>
            public int Start { get; set; }

            /// <summary>
            /// Number of records that the table can display in the current draw. It is expected
            /// that the number of records returned will be equal to this number, unless the server
            /// has fewer records to return. Note that this can be -1 to indicate that all records
            /// should be returned (although that negates any benefits of server-side processing!)
            /// </summary>
            public int Length { get; set; }

            /// <summary>
            /// Global search value. To be applied to all columns which have searchable as true.
            /// </summary>
            public DTSearch Search { get; set; }

            /// <summary>
            /// Custom column that is used to further sort on the first Order column.
            /// </summary>
            public string SortOrder
            {
                get
                {
                    return Columns != null && Order != null && Order.Length > 0
                        ? (Columns[Order[0].Column].Data + (Order[0].Dir == DTOrderDir.DESC ? " " + Order[0].Dir : string.Empty))
                        : null;
                }
            }

            public string GenericSearch { get; set; }

            public string SensorFilter { get; set; }

            public DateTime? StartDate { get; set; }

            public DateTime? EndDate { get; set; }

            public int? Status { get; set; }

            public string Empno { get; set; }
            public string EmpType { get; set; }

            public string BusinessEntityId { get; set; }

            public string LeaveType { get; set; }
            public string OndutyType { get; set; }
            public string WorkArea { get; set; }
            public string AreaCategory { get; set; }
            public string Office { get; set; }
            public string Floor { get; set; }
            public string Wing { get; set; }

            public string Parent { get; set; }
            public string Assign { get; set; }

            public string EmployeeType { get; set; }
            public string PrimaryWorkspace { get; set; }
            public string PrimaryWorkspaceList { get; set; }
            public string EligibleForSWP { get; set; }
            public string LaptopUser { get; set; }
            public string Grade { get; set; }
            public int? IsActive { get; set; }
            public int? IsActiveFuture { get; set; }

            public string Unqid { get; set; }
            public string ApplicationId { get; set; }
            public string DeskAssignmentStatus { get; set; }

            public string Projno { get; set; }
            public string Currency { get; set; }

            public string CompanyCode { get; set; }

            public string Vendor { get; set; }

            public string Costcode { get; set; }
            public string Statusstring { get; set; }

            public string JobRefCode { get; set; }

            public string Location { get; set; }

            public DateTime? OpenFromDate { get; set; }

            public DateTime? OpenToDate { get; set; }

            public DateTime? BgFromDate { get; set; }

            public DateTime? BgToDate { get; set; }

            public DateTime? BgValFromDate { get; set; }

            public DateTime? BgValToDate { get; set; }

            public DateTime? BgClaimFromDate { get; set; }

            public DateTime? BgClaimToDate { get; set; }

            public string Refnum { get; set; }

            public string BgType { get; set; }

            public string OscmId { get; set; }

            public string OscdId { get; set; }
            public string TransId { get; set; }

            public string ConsumableId { get; set; }

            public string InvGroupId { get; set; }
            public string ModuleId { get; set; }
            public string RoleId { get; set; }
            public string ActionId { get; set; }
            public decimal? IsPrimaryOpen { get; set; }
            public decimal? IsSecondaryOpen { get; set; }
            public decimal? IsNominationOpen { get; set; }
            public decimal? IsMediclaimOpen { get; set; }
            public decimal? IsAadhaarOpen { get; set; }
            public decimal? IsPassportOpen { get; set; }
            public decimal? IsGtliOpen { get; set; }
            public string ExEmpno { get; set; }
            public string SubmitStatus { get; set; }
            public decimal? IsBlocked { get; set; }

            public string Department { get; set; }
            public string Designation { get; set; }
            public string PcModelList { get; set; }
            public string MonitorModel { get; set; }
            public decimal? DualMonitor { get; set; }
            public decimal? VacantDesk { get; set; }
            public string TelModel { get; set; }
            public string PrinterModel { get; set; }
            public string DocstnModel { get; set; }
            public string OfficeLocationCode { get; set; }
            public string ToDept { get; set; }
            public string FromDept { get; set; }
            public string ResignStatusCode { get; set; }
            public string Lot { get; set; }
            public string Id { get; set; }
            public string yymm { get; set; }
            public string KeyId { get; set; }
            public string CurrentCostcode { get; set; }
            public string TargetCostcode { get; set; }
            public string AreaId { get; set; }
            public string CostCode { get; set; }
            public string ProjectNo { get; set; }
            public string DeskType { get; set; }
            public decimal? IsRestricted { get; set; }
            public string AreaCatgCode { get; set; }
            public string AreaType { get; set; }
            public string TagId { get; set; }
            public string ObjTypeId { get; set; }
            public string Cabin { get; set; }
            public string BookingDate { get; set; }
            public decimal? IsPresent { get; set; }
            public decimal? IsDeskBooked { get; set; }
            public decimal? IsCrossAttend { get; set; }
            public string RegionCode { get; set; }
            public string Yyyymm { get; set; }

            public string Year { get; set; }
            public string GroupType { get; set; }
            public string AssetType { get; set; }
            public bool? IsYes {  get; set; } 
            public string YearMode {  get; set; } 
            public string Yyyy {  get; set; } 
        }

        /// <summary>
        /// A jQuery DataTables column.
        /// </summary>
        public class DTColumn
        {
            /// <summary>
            /// Column's data source, as defined by columns.data.
            /// </summary>
            public string Data { get; set; }

            /// <summary>
            /// Column's name, as defined by columns.name.
            /// </summary>
            public string Name { get; set; }

            /// <summary>
            /// Flag to indicate if this column is searchable (true) or not (false). This is
            /// controlled by columns.searchable.
            /// </summary>
            public bool Searchable { get; set; }

            /// <summary>
            /// Flag to indicate if this column is orderable (true) or not (false). This is
            /// controlled by columns.orderable.
            /// </summary>
            public bool Orderable { get; set; }

            /// <summary>
            /// Specific search value.
            /// </summary>
            public DTSearch Search { get; set; }
        }

        /// <summary>
        /// An order, as sent by jQuery DataTables when doing AJAX queries.
        /// </summary>
        public class DTOrder
        {
            /// <summary>
            /// Column to which ordering should be applied. This is an index reference to the
            /// columns array of information that is also submitted to the server.
            /// </summary>
            public int Column { get; set; }

            /// <summary>
            /// Ordering direction for this column. It will be dt-string asc or dt-string desc to
            /// indicate ascending ordering or descending ordering, respectively.
            /// </summary>
            public DTOrderDir Dir { get; set; }
        }

        /// <summary>
        /// Sort orders of jQuery DataTables.
        /// </summary>
        public enum DTOrderDir
        {
            ASC,
            DESC
        }

        /// <summary>
        /// A search, as sent by jQuery DataTables when doing AJAX queries.
        /// </summary>
        public class DTSearch
        {
            /// <summary>
            /// Global search value. To be applied to all columns which have searchable as true.
            /// </summary>
            public string Value { get; set; }

            /// <summary>
            /// true if the global filter should be treated as a regular expression for advanced
            /// searching, false otherwise. Note that normally server-side processing scripts will
            /// not perform regular expression searching for performance reasons on large data sets,
            /// but it is technically possible and at the discretion of your script.
            /// </summary>
            public bool Regex { get; set; }
        }

        public class DTResultExtension<T, HD> : DTResult<T>
        {
            public HD headerData { get; set; }

            public string error { get; set; }
        }
    }
}
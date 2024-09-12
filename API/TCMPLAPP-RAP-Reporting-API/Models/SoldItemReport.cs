using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.Models
{
    public class SoldItemReport
    {
        [Key]
        public string Company { get; set; }

        public string Branch { get; set; }
        public string Phone { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public List<SoldItem> SoldItems { get; set; }

        public SoldItemReport(string company, string branch, string phone, string fromDate, string toDate, List<SoldItem> soldItems)
        {
            Company = company;
            Branch = branch;
            Phone = phone;
            FromDate = fromDate;
            ToDate = toDate;
            SoldItems = soldItems;
        }
    }

    public class AuditorItemReport
    {
        [Key]
        public string Id { get; set; }

        public List<AuditorItem> AuditorItems { get; set; }

        public AuditorItemReport(string id, List<AuditorItem> auditorItems)
        {
            Id = id;
            AuditorItems = auditorItems;
        }
    }
}
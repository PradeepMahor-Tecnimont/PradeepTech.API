namespace RapReportingApi.Models
{
    public class SoldItem
    {
        public int ShowableId { get; set; }
        public string Name { get; set; }
        public int OrderCount { get; set; }
        public int Price { get; set; }
        public int TotalSale { get => OrderCount * Price; }

        public SoldItem(int showableId, string name, int orderCount, int price)
        {
            ShowableId = showableId;
            Name = name;
            OrderCount = orderCount;
            Price = price;
        }

        public override string ToString()
        {
            return "ShowableId { ShowableId=" + ShowableId + ", Name=" + Name
                + ", OrderCount=" + OrderCount + ", Price=" + Price
                + ", TotalSale=" + TotalSale + "}";
        }
    }

    public class AuditorItem
    {
        public int Srno { get; set; }
        public string Company { get; set; }
        public string Tmagrp { get; set; }
        public string Emptype { get; set; }
        public string Location { get; set; }
        public string Yymm { get; set; }
        public string Costcode { get; set; }
        public string Projno { get; set; }
        public string Name { get; set; }
        public decimal Hours { get; set; }
        public decimal Othours { get; set; }
        public decimal Tothours { get; set; }

        public AuditorItem(int srno, string company, string tmagrp, string emptype, string location,
                           string yymm, string costcode, string projno, string name, decimal hours,
                           decimal othours, decimal tothours)
        {
            Srno = srno;
            Company = company;
            Tmagrp = tmagrp;
            Emptype = emptype;
            Yymm = yymm;
            Location = location;
            Costcode = costcode;
            Projno = projno;
            Name = name;
            Hours = hours;
            Othours = othours;
            Tothours = tothours;
        }

        public override string ToString()
        {
            return "Srno { Srno=" + Srno + ", Company=" + Company + ", Tmagrp=" + Tmagrp + ", Emptype=" + Emptype
                + ", Yymm=" + Yymm + ", Location=" + Location + ", Costcode=" + Costcode
                + ", Projno=" + Projno + ", Name=" + Name + ", Hours=" + Hours + ", Othours=" + Othours
                + ", Tothours=" + Tothours + "}";
        }
    }
}
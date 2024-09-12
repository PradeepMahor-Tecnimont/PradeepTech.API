using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookingHelper
    {
        public const string RoleDeskBooking = "R103";
        public const string RoleManagerHoD = "R002";
        public const string RoleAdminDeskBooking = "R104";
        public const string RoleMonitorDeskBooking = "R108";
        public const string RoleCabinBookAdmin = "R111";
        public const string RoleCabinBookingEmployee = "R112";

        public const string ActionDeskBookingCreate = "A222";
        public const string ActionDeskBookAdmin = "A223";
        public const string ActionDeskBookDept = "A224";
        public const string ActionDeskBookUser = "A227";

        public const string ActionDeskBookMonitor = "A241";
        public const string ActionCabinBookAdmin = "A252";
        public const string ActionCabinBookEmployee= "A253";
    }
}
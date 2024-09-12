using Microsoft.EntityFrameworkCore;

namespace RapReportingApi.RAPEntityModels
{
    public partial class RAPDbContext : DbContext
    {
        public RAPDbContext()
        {
        }

        public RAPDbContext(DbContextOptions<RAPDbContext> options)
            : base(options)
        {
        }

        // Unable to generate entity type for table 'RAP_TIMECURR.HOLIDAYS'. Please see the warning
        // messages. Unable to generate entity type for table 'RAP_TIMECURR.JOBMAST'. Please see the
        // warning messages. Unable to generate entity type for table
        // 'RAP_TIMECURR.SUBCONTRACTMAST'. Please see the warning messages.

    }
}
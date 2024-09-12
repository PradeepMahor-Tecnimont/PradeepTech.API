using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Context
{
    public partial class ExecDBContext : DbContext
    {
        public ExecDBContext()
        {
        }
        public ExecDBContext(DbContextOptions<ExecDBContext> options) : base(options)
        {
        }

    }
}

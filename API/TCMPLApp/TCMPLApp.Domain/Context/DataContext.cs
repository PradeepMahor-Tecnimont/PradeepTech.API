using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using TCMPLApp.Domain.Models.SWPVaccine;

using System.Reflection;

namespace TCMPLApp.Domain.Context
{
    public partial class DataContext : DbContext
    {
        public DataContext()
        {
        }
        public DataContext(DbContextOptions<DataContext> options) : base(options)
        {
        }

        public virtual DbSet<SsCostmast> SsCostmasts { get; set; }
        public virtual DbSet<SsEmplmast> SsEmplmasts { get; set; }
        public virtual DbSet<SwpVuEmpResponse> SwpVuEmpResponses { get; set; }
        public virtual DbSet<SwpVuEmpVaccineDate> SwpVuEmpVaccineDate { get; set; }

        public virtual DbSet<SwpIsp> SwpISPs { get; set; }

        public virtual DbSet<SwpVaccineMaster> SwpVaccineMaster { get; set; }
        public virtual DbSet<SwpBusRoute> SwpBusRoutes { get; set; }

        //public virtual DbSet<SwpVaccinationOffice> SwpVaccinationOffices { get; set; }

        //public virtual DbSet<SwpTplVaccineBatch> SwpTplVaccineBatch { get; set; }

        //public virtual DbSet<SwpTplVaccineBatchEmp> SwpTplVaccineBatchEmp { get; set; }

        //public virtual DbSet<SwpVuTplVaccineBatchDet> SwpVuTplVaccineBatchDets { get; set; }
        
        //public virtual DbSet<SwpVuVaccineOffBatch2Regn> SwpVuVaccineOffBatch2Regns { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

            modelBuilder.HasDefaultSchema("SELFSERVICE");
            modelBuilder.HasSequence("NETWORK_PRINTER_DATA_SEQ");

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}

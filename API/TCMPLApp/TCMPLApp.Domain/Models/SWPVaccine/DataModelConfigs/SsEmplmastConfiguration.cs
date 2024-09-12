using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SsEmplmastConfiguration : IEntityTypeConfiguration<SsEmplmast>
    {
        public void Configure(EntityTypeBuilder<SsEmplmast> entity)
        {
            entity.ToView("SS_EMPLMAST");

            entity.Property(e => e.Abbr)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.AmfiAuth).HasPrecision(1);

            entity.Property(e => e.AmfiUser).HasPrecision(1);

            entity.Property(e => e.Assign)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Category).IsUnicode(false);

            entity.Property(e => e.Company)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Costdy).HasPrecision(1);

            entity.Property(e => e.Costhead).HasPrecision(1);

            entity.Property(e => e.Costopr).HasPrecision(1);

            entity.Property(e => e.Dba).HasPrecision(1);

            entity.Property(e => e.Desgcode)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Director).HasPrecision(1);

            entity.Property(e => e.Dirop).HasPrecision(1);

            entity.Property(e => e.Do)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Email).IsUnicode(false);

            entity.Property(e => e.EmpHod)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Empno)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Emptype)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Eow)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.EowWeek).HasPrecision(1);

            entity.Property(e => e.EsiCover).HasPrecision(1);

            entity.Property(e => e.Expatriate).HasPrecision(1);

            entity.Property(e => e.Firstname).IsUnicode(false);

            entity.Property(e => e.Grade).IsUnicode(false);

            entity.Property(e => e.HrOpr).HasPrecision(1);

            entity.Property(e => e.InvAuth).HasPrecision(1);

            entity.Property(e => e.Ipadd).IsUnicode(false);

            entity.Property(e => e.JobIncharge).HasPrecision(1);

            entity.Property(e => e.Jobtitle).IsUnicode(false);

            entity.Property(e => e.Lastname).IsUnicode(false);

            entity.Property(e => e.Married)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Middlename).IsUnicode(false);

            entity.Property(e => e.Mngr)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Name).IsUnicode(false);

            entity.Property(e => e.Newemp).HasPrecision(1);

            entity.Property(e => e.Office)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Oldco)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Ondeputation).HasPrecision(1);

            entity.Property(e => e.Parent)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Password)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Payroll).HasPrecision(1);

            entity.Property(e => e.Personid)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Pfslno).IsUnicode(false);

            entity.Property(e => e.ProcOpr).HasPrecision(1);

            entity.Property(e => e.Projdy).HasPrecision(1);

            entity.Property(e => e.Projmngr).HasPrecision(1);

            entity.Property(e => e.Projno)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.PwdChgd).HasPrecision(1);

            entity.Property(e => e.Reporto)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Seatreq).HasPrecision(1);

            entity.Property(e => e.Secretary).HasPrecision(1);

            entity.Property(e => e.Sex)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Status).HasPrecision(1);

            entity.Property(e => e.Submit).HasPrecision(1);

            entity.Property(e => e.UserDomain).IsUnicode(false);

            entity.Property(e => e.WebItdecl).HasPrecision(1);

        }
    }
}
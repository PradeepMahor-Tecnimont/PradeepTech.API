using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HSE
{
    public class HSEQuizDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        public string QuizId { get; set; }
        public string QuestionId { get; set; }
        public string QuestionName { get; set; }
        public decimal AnswerId { get; set; }
        public decimal CorrectAnswerId { get; set; }
        public string CorrectAnswerText { get; set; }
        public string AnswerIdText { get; set; }
    }
}

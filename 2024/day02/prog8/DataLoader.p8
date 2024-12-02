%import diskio
%import syslib
%import textio
%import ReportList

DataLoader {
    sub open(uword filename) {
        if not diskio.f_open(filename) {
           txt.print("no data file")
           txt.nl()
           sys.exit(1)
        }
    }

    bool eof = false

    sub get_reports(uword reportList) -> ubyte {
        ubyte count, report, i, bytes, status, c
        ubyte[81] linebuffer 
        if eof {
            eof = false
            ReportList.set_count(reportList, 0)
            return 0
        }

        bytes, status = diskio.f_readline(linebuffer) 
        if status & 64 != 0 { eof = true }
        if bytes == 0 { return 0 }
        count = 0
        report = 0
        for i in 0 to bytes - 1 {
            c = linebuffer[i]
            if c >= '0' and c <= '9' {
                report = report * 10 + c - '0'
            } else {
                ReportList.set_reports_item(reportList, count, report)
                count += 1
                report = 0
            }
        }
        if report > 0  {
            ReportList.set_reports_item(reportList, count, report)
            count += 1
        }
        ReportList.set_count(reportList, count)
        return count
    }
}

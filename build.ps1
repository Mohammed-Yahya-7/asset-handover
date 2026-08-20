# Read logo as base64 data URI
$b64 = (Get-Content "D:\project\asset-handover\logo_b64.txt" -Raw).Trim()
$logoSrc = "data:image/png;base64,$b64"

$html = @"
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>نموذج استلام / تسليم عهدة - آفاق العربية</title>
  <meta name="description" content="نموذج استلام وتسليم العهدة الرسمي لشركة آفاق العربية للنقل والتخزين" />
  <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;800&display=swap" rel="stylesheet" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
  <style>
    :root {
      --primary: #1a3a6b;
      --accent: #2563a8;
      --border: #333;
      --red: #c0392b;
      --bg: #f0f4fb;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Cairo', Arial, sans-serif;
      background: var(--bg);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 24px 16px 40px;
    }
    /* ── Button ── */
    .btn-download {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      background: linear-gradient(135deg, #1a3a6b, #2563a8);
      color: #fff;
      font-family: 'Cairo', sans-serif;
      font-size: 17px;
      font-weight: 700;
      padding: 13px 40px;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      box-shadow: 0 4px 20px rgba(26,58,107,0.3);
      transition: transform .15s, box-shadow .15s;
      margin-bottom: 24px;
    }
    .btn-download:hover { transform: translateY(-2px); box-shadow: 0 8px 30px rgba(26,58,107,0.4); }
    .btn-download svg { width: 22px; height: 22px; fill: #fff; flex-shrink: 0; }
    /* ── A4 Sheet ── */
    #form-sheet {
      width: 210mm;
      min-height: 297mm;
      background: #fff;
      box-shadow: 0 4px 40px rgba(0,0,0,0.13);
      padding: 13mm 13mm 15mm 13mm;
    }
    /* ── Header ── */
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 2.5px solid var(--primary);
      padding-bottom: 3mm;
      margin-bottom: 4mm;
    }
    .header-meta { font-size: 11px; color: #333; line-height: 1.8; }
    .header-meta b { color: var(--primary); }
    .logo-img { height: 58px; object-fit: contain; background: #fff; }
    /* ── Title ── */
    .form-title-wrap { text-align: center; margin: 3mm 0; }
    .form-title { font-size: 20px; font-weight: 800; color: var(--primary); text-decoration: underline; }
    /* ── Operation row ── */
    .operation-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 2.5mm 5mm;
      background: #eef2fa;
      border: 1px solid #c5d3e8;
      border-radius: 5px;
      margin-bottom: 3.5mm;
    }
    .operation-label { font-size: 12px; font-weight: 700; color: var(--primary); }
    .chk-group { display: flex; gap: 18px; }
    .chk-item { display: flex; align-items: center; gap: 5px; font-size: 12px; font-weight: 600; cursor: pointer; }
    .chk-item input[type=checkbox] { width: 15px; height: 15px; accent-color: var(--primary); cursor: pointer; }
    /* ── Section title ── */
    .sec-title {
      font-size: 13px; font-weight: 800; color: var(--primary);
      border-right: 4px solid var(--accent);
      padding-right: 7px; margin: 3mm 0 2mm;
    }
    /* ── Info table ── */
    .info-table { width: 100%; border-collapse: collapse; margin-bottom: 4mm; font-size: 12px; }
    .info-table td { border: 1px solid var(--border); padding: 4px 7px; vertical-align: middle; }
    .info-table .lbl { font-weight: 700; color: var(--primary); background: #eef2fa; width: 95px; white-space: nowrap; }
    .info-table .val input {
      width: 100%; border: none; outline: none; font-family: 'Cairo', sans-serif;
      font-size: 12px; background: transparent; padding: 2px 0;
    }
    /* ── Assets table ── */
    .assets-table { width: 100%; border-collapse: collapse; margin-bottom: 4mm; font-size: 11px; }
    .assets-table th {
      background: var(--primary); color: #fff;
      padding: 6px 5px; text-align: center;
      border: 1px solid var(--border); font-size: 11.5px;
    }
    .assets-table td { border: 1px solid #555; padding: 4px 5px; text-align: center; vertical-align: middle; }
    .assets-table tr:nth-child(even) td { background: #f7f9fd; }
    .assets-table .a-name { text-align: right; font-weight: 700; color: var(--primary); white-space: nowrap; }
    .assets-table .a-num { font-weight: 800; color: var(--primary); width: 24px; }
    .assets-table td input[type=text] {
      width: 100%; border: none; outline: none; font-family: 'Cairo', sans-serif;
      font-size: 11px; background: transparent; text-align: center; padding: 2px 0;
    }
    .chk-cell { display: flex; justify-content: center; gap: 10px; }
    .chk-cell label { display: flex; align-items: center; gap: 3px; font-size: 10.5px; cursor: pointer; }
    .chk-cell input[type=checkbox] { width: 13px; height: 13px; accent-color: var(--primary); cursor: pointer; }
    /* ── Declaration ── */
    .decl-box {
      border: 1.5px solid var(--primary); border-radius: 6px;
      padding: 5mm 7mm; background: #f9fbff; margin-bottom: 4mm;
    }
    .decl-title { font-size: 13px; font-weight: 800; color: var(--red); margin-bottom: 2.5mm; }
    .decl-text { font-size: 11.5px; line-height: 1.9; color: #222; text-align: justify; }
    /* ── Notes ── */
    .notes-box { margin-bottom: 4mm; }
    .notes-box textarea {
      width: 100%; border: 1px dashed #aaa; border-radius: 4px;
      padding: 5px 8px; font-family: 'Cairo', sans-serif; font-size: 11.5px;
      resize: none; outline: none; background: #fafcff; min-height: 36px;
      line-height: 1.8;
    }
    /* ── Signatures ── */
    .sig-row { display: flex; gap: 14px; margin-top: 5mm; }
    .sig-block { flex: 1; }
    .sig-lbl { font-size: 11.5px; font-weight: 700; color: var(--primary); margin-bottom: 2mm; }
    .sig-line { border-bottom: 1.5px dashed #888; min-height: 24px; }
    /* ── Footer ── */
    .form-footer {
      margin-top: 6mm; padding-top: 3mm;
      border-top: 1.5px solid var(--primary);
      display: flex; justify-content: space-between;
      font-size: 10px; color: #666;
    }
    /* ── Print ── */
    @media print {
      body { background:#fff; padding:0; }
      .btn-download { display:none !important; }
      #form-sheet { box-shadow:none; }
      .info-table .val input, .assets-table td input[type=text], .notes-box textarea { border-bottom: 1px solid #ccc; }
    }
  </style>
</head>
<body>

  <button class="btn-download" onclick="downloadPDF()" id="btn-pdf">
    <svg viewBox="0 0 24 24"><path d="M12 16l-5-5h3V4h4v7h3l-5 5zm-7 2h14v2H5v-2z"/></svg>
    تحميل النموذج PDF
  </button>

  <div id="form-sheet">

    <!-- ── Header ── -->
    <div class="header">
      <div class="header-meta">
        <div><b>الموافق: </b><span id="today-date"></span></div>
        <div><b>رقم النموذج: </b>AF-HD-001</div>
      </div>
      <img class="logo-img" src="$logoSrc" alt="آفاق العربية للنقل والتخزين" />
    </div>

    <!-- ── Title ── -->
    <div class="form-title-wrap">
      <div class="form-title">نموذج استلام / تسليم عهدة</div>
    </div>

    <!-- ── Operation Type ── -->
    <div class="operation-row">
      <div class="operation-label">نوع العملية:</div>
      <div class="chk-group">
        <label class="chk-item"><input type="checkbox" id="op-tasleem" /> تسليم عهدة</label>
        <label class="chk-item"><input type="checkbox" id="op-istelam" /> استلام عهدة</label>
      </div>
    </div>

    <!-- ── Personal Info ── -->
    <div class="sec-title">أولاً: البيانات الشخصية</div>
    <table class="info-table">
      <tr>
        <td class="lbl">الاسم</td>
        <td class="val"><input type="text" id="f-name" placeholder="اكتب الاسم الكامل" /></td>
        <td class="lbl">رقم الجوال</td>
        <td class="val"><input type="text" id="f-phone" placeholder="05xxxxxxxx" /></td>
      </tr>
      <tr>
        <td class="lbl">رقم الهوية</td>
        <td class="val"><input type="text" id="f-id" placeholder="1xxxxxxxxx" /></td>
        <td class="lbl">القسم</td>
        <td class="val"><input type="text" id="f-dept" placeholder="اسم القسم" /></td>
      </tr>
      <tr>
        <td class="lbl">البريد الإلكتروني</td>
        <td class="val"><input type="text" id="f-email" placeholder="example@afaq.com" /></td>
        <td class="lbl">المسمى الوظيفي</td>
        <td class="val"><input type="text" id="f-title" placeholder="المسمى الوظيفي" /></td>
      </tr>
    </table>

    <!-- ── Assets Table ── -->
    <div class="sec-title">ثانياً: تفاصيل العهدة</div>
    <table class="assets-table">
      <thead>
        <tr>
          <th>م</th>
          <th>نوع العهدة</th>
          <th>النوع / الماركة</th>
          <th>الرقم التسلسلي</th>
          <th>الحالة</th>
          <th>هل تم الاستلام أو التسليم</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="a-num">1</td>
          <td class="a-name">جوال</td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><div class="chk-cell">
            <label><input type="checkbox" /> نعم</label>
            <label><input type="checkbox" /> لا</label>
          </div></td>
        </tr>
        <tr>
          <td class="a-num">2</td>
          <td class="a-name">لاب توب</td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><div class="chk-cell">
            <label><input type="checkbox" /> نعم</label>
            <label><input type="checkbox" /> لا</label>
          </div></td>
        </tr>
        <tr>
          <td class="a-num">3</td>
          <td class="a-name">كمبيوتر مكتبي</td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><div class="chk-cell">
            <label><input type="checkbox" /> نعم</label>
            <label><input type="checkbox" /> لا</label>
          </div></td>
        </tr>
        <tr>
          <td class="a-num">4</td>
          <td class="a-name">طابعة</td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><div class="chk-cell">
            <label><input type="checkbox" /> نعم</label>
            <label><input type="checkbox" /> لا</label>
          </div></td>
        </tr>
        <tr>
          <td class="a-num">5</td>
          <td class="a-name">ماسح ضوئي</td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><div class="chk-cell">
            <label><input type="checkbox" /> نعم</label>
            <label><input type="checkbox" /> لا</label>
          </div></td>
        </tr>
        <tr>
          <td class="a-num">6</td>
          <td class="a-name">شريحة جوال</td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><div class="chk-cell">
            <label><input type="checkbox" /> نعم</label>
            <label><input type="checkbox" /> لا</label>
          </div></td>
        </tr>
        <tr>
          <td class="a-num">7</td>
          <td class="a-name">مودم</td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><div class="chk-cell">
            <label><input type="checkbox" /> نعم</label>
            <label><input type="checkbox" /> لا</label>
          </div></td>
        </tr>
        <tr>
          <td class="a-num">8</td>
          <td class="a-name">عهد أخرى</td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><input type="text" placeholder="..." /></td>
          <td><div class="chk-cell">
            <label><input type="checkbox" /> نعم</label>
            <label><input type="checkbox" /> لا</label>
          </div></td>
        </tr>
      </tbody>
    </table>

    <!-- ── Declaration ── -->
    <div class="decl-box">
      <div class="decl-title">ثالثاً: نص الإقرار</div>
      <div class="decl-text">
        أقر أنا الموظف، أعلاه باستلام / تسليم العهد الموضحة أعلاه، وأتعهد بالمحافظة عليها واستخدامها بما يتحقق من أهدافها للأغراض الرسمية فقط، وفي حال تلفها أو إتلافها أتحمل المسؤولية حسب أنظمة الشركة.
      </div>
    </div>

    <!-- ── Notes ── -->
    <div class="sec-title">ملاحظات</div>
    <div class="notes-box">
      <textarea id="f-notes" rows="2" placeholder="أي ملاحظات إضافية..."></textarea>
    </div>

    <!-- ── Signatures ── -->
    <div class="sec-title">رابعاً: التوقيعات</div>
    <div class="sig-row">
      <div class="sig-block">
        <div class="sig-lbl">الاسم:</div>
        <div class="sig-line"></div>
      </div>
      <div class="sig-block">
        <div class="sig-lbl">التوقيع / البصمة:</div>
        <div class="sig-line"></div>
      </div>
      <div class="sig-block">
        <div class="sig-lbl">التاريخ:</div>
        <div class="sig-line"></div>
      </div>
      <div class="sig-block">
        <div class="sig-lbl">اعتماد المسؤول:</div>
        <div class="sig-line"></div>
      </div>
    </div>

    <!-- ── Footer ── -->
    <div class="form-footer">
      <span>آفاق العربية للنقل والتخزين &mdash; شركة مساهمة مقفلة</span>
      <span>AF-HD-001 | نسخة 1.0</span>
    </div>

  </div><!-- /form-sheet -->

  <script>
    // Today's date
    const d = new Date();
    document.getElementById('today-date').textContent =
      d.toLocaleDateString('ar-SA', {year:'numeric', month:'2-digit', day:'2-digit'});

    // PDF Download
    function downloadPDF() {
      const btn = document.getElementById('btn-pdf');
      btn.textContent = '⏳ جاري التحضير...';
      btn.disabled = true;

      // Hide placeholders for clean PDF
      document.querySelectorAll('input[type=text], textarea').forEach(el => {
        el.setAttribute('data-ph', el.placeholder);
        el.placeholder = '';
      });

      const el = document.getElementById('form-sheet');
      const opt = {
        margin: 0,
        filename: 'نموذج_تسليم_عهدة_آفاق_العربية.pdf',
        image: { type: 'jpeg', quality: 0.97 },
        html2canvas: { scale: 2, useCORS: true, logging: false, allowTaint: true },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
      };

      html2pdf().set(opt).from(el).save().then(() => {
        btn.innerHTML = '<svg viewBox="0 0 24 24" style="width:22px;height:22px;fill:#fff"><path d="M12 16l-5-5h3V4h4v7h3l-5 5zm-7 2h14v2H5v-2z"/></svg> تحميل النموذج PDF';
        btn.disabled = false;
        // Restore placeholders
        document.querySelectorAll('input[type=text], textarea').forEach(el => {
          el.placeholder = el.getAttribute('data-ph') || '';
        });
      });
    }
  </script>

</body>
</html>
"@

$html | Out-File -FilePath "D:\project\asset-handover\index.html" -Encoding UTF8
Write-Host "Done - index.html written successfully"

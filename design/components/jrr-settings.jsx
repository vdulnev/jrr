// ═══════════════════════════════════════════════════════════════
// SETTINGS / SERVER MANAGER SCREEN
// ═══════════════════════════════════════════════════════════════

function InfoCard({ title, children }) {
  return (
    <div style={{ marginBottom: 24 }}>
      <div style={{ fontFamily:T.mono, fontSize:9, letterSpacing:2, color:T.text3, textTransform:'uppercase', marginBottom:10, paddingLeft:4 }}>{title}</div>
      <div style={{ background:T.bg2, borderRadius:12, border:`1px solid ${T.line}`, overflow:'hidden' }}>
        {children}
      </div>
    </div>
  );
}

function InfoRow({ label, value, mono=true, last=false }) {
  return (
    <div style={{ padding:'12px 16px', display:'flex', justifyContent:'space-between', alignItems:'center',
      borderBottom: last ? 'none' : `1px solid ${T.line}` }}>
      <span style={{ fontSize:12, color:T.text3 }}>{label}</span>
      <span style={{ fontSize:13, color:T.text, fontFamily: mono ? T.mono : T.sans }}>{value}</span>
    </div>
  );
}

function FailedDownloadRow({ title, subtitle, onRetry, onRemove, last }) {
  return (
    <div style={{ padding:'10px 8px 10px 16px', display:'flex', alignItems:'center', gap:6,
      borderBottom: last ? 'none' : `1px solid ${T.line}` }}>
      <div style={{ flex:1, minWidth:0 }}>
        <div style={{ fontSize:13, color:T.text, whiteSpace:'nowrap', overflow:'hidden', textOverflow:'ellipsis' }}>{title}</div>
        <div style={{ fontSize:11, color:T.text3, marginTop:2, whiteSpace:'nowrap', overflow:'hidden', textOverflow:'ellipsis' }}>{subtitle}</div>
      </div>
      <button onClick={onRetry} title="Retry" style={{ background:'none', border:'none', cursor:'pointer', padding:8, color:T.text2, display:'flex' }}>
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><path d="M14 8a6 6 0 11-1.76-4.24M14 2v4h-4"/></svg>
      </button>
      <button onClick={onRemove} title="Remove" style={{ background:'none', border:'none', cursor:'pointer', padding:8, color:'#ef4444', display:'flex' }}>
        <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><path d="M2 2l10 10M12 2L2 12"/></svg>
      </button>
    </div>
  );
}

function SettingsScreen() {
  const [downloads, setDownloads] = React.useState({ count: 142, sizeMB: 1872 });
  const [failed, setFailed] = React.useState([
    { id:1, title:'Tutu', subtitle:'Miles Davis • Connection timeout' },
    { id:2, title:'Maiden Voyage', subtitle:'Herbie Hancock • HTTP 503' },
  ]);
  const [confirm, setConfirm] = React.useState(null);

  const fmtMB = mb => mb >= 1024 ? `${(mb/1024).toFixed(1)} GB` : `${mb.toFixed(1)} MB`;

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100%', animation:'fadeIn 0.3s ease', position:'relative' }}>
      <div style={{ padding:'56px 20px 16px' }}>
        <div style={{ fontFamily:T.mono, fontSize:9, letterSpacing:3, color:T.accent, textTransform:'uppercase', marginBottom:6 }}>Connection</div>
        <div style={{ fontSize:24, fontWeight:700, color:T.text, letterSpacing:-0.5 }}>Server Manager</div>
      </div>

      <div style={{ flex:1, overflowY:'auto', padding:'8px 20px 120px' }}>
        <InfoCard title="Connected Server">
          <InfoRow label="Name" value="Living Room Mac"/>
          <InfoRow label="Version" value="33.0.40"/>
          <InfoRow label="Address" value="192.168.1.10:52199"/>
          <InfoRow label="Platform" value="macOS" last/>
        </InfoCard>

        <InfoCard title="Offline Storage">
          <InfoRow label="Downloaded Tracks" value={`${downloads.count}`}/>
          <InfoRow label="Total Size" value={fmtMB(downloads.sizeMB)}/>
          <div style={{ padding:14 }}>
            <button onClick={()=>setConfirm({
              title:'Clear all downloads?',
              message:'This will delete all downloaded tracks and artwork from your device.',
              confirmLabel:'Clear All',
              onConfirm:()=>setDownloads({count:0,sizeMB:0}),
            })} style={{
              width:'100%', padding:'10px 14px', borderRadius:8, border:`1px solid #ef4444`,
              background:'transparent', color:'#ef4444', fontSize:13, fontWeight:500, cursor:'pointer',
              fontFamily:T.sans, display:'flex', alignItems:'center', justifyContent:'center', gap:8,
            }}>
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><path d="M2 4h10M4 4V2h6v2M5 4v8M9 4v8M3 4l1 9h6l1-9"/></svg>
              Clear All Downloads
            </button>
          </div>
        </InfoCard>

        {failed.length > 0 && (
          <InfoCard title={`Failed Downloads (${failed.length})`}>
            {failed.map((f,i)=>(
              <FailedDownloadRow key={f.id} title={f.title} subtitle={f.subtitle}
                last={i===failed.length-1}
                onRetry={()=>setFailed(fs=>fs.filter(x=>x.id!==f.id))}
                onRemove={()=>setFailed(fs=>fs.filter(x=>x.id!==f.id))}/>
            ))}
          </InfoCard>
        )}

        <InfoCard title="Audio Quality (Local Playback)">
          <QualitySelector/>
        </InfoCard>

        <InfoCard title="Diagnostics">
          <div style={{ padding:14 }}>
            <button style={{
              width:'100%', padding:'10px 14px', borderRadius:8, border:`1px solid ${T.line2}`,
              background:'transparent', color:T.text, fontSize:13, cursor:'pointer',
              fontFamily:T.sans, display:'flex', alignItems:'center', justifyContent:'center', gap:8,
            }}>
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><path d="M7 1v9M3 6l4 4 4-4M1 13h12"/></svg>
              Export Logs
            </button>
          </div>
        </InfoCard>

        <button onClick={()=>setConfirm({
          title:'Sign out?',
          message:'You will be returned to the server setup screen.',
          confirmLabel:'Sign Out',
          onConfirm:()=>{},
        })} style={{
          width:'100%', padding:'12px 14px', borderRadius:10, border:'none',
          background:T.bg3, color:'#ef4444', fontSize:14, fontWeight:500, cursor:'pointer',
          fontFamily:T.sans, display:'flex', alignItems:'center', justifyContent:'center', gap:8, marginTop:8,
        }}>
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><path d="M10 4V2H2v12h8v-2M6 8h9M12 5l3 3-3 3"/></svg>
          Logout
        </button>
      </div>

      {confirm && <ConfirmDialog {...confirm} onClose={()=>setConfirm(null)}/>}
    </div>
  );
}

function QualitySelector() {
  const [quality, setQuality] = React.useState('lossless');
  const opts = [
    { id:'lossless', label:'Lossless', sub:'Original FLAC / WAV' },
    { id:'high', label:'High', sub:'320 kbps MP3' },
    { id:'medium', label:'Medium', sub:'192 kbps MP3' },
  ];
  return (
    <div>
      {opts.map((o,i)=>(
        <div key={o.id} onClick={()=>setQuality(o.id)} style={{
          padding:'12px 16px', display:'flex', alignItems:'center', gap:12, cursor:'pointer',
          borderBottom: i===opts.length-1 ? 'none' : `1px solid ${T.line}`,
        }}>
          <div style={{ width:18, height:18, borderRadius:'50%', border:`1.5px solid ${quality===o.id?T.accent:T.line2}`,
            display:'flex', alignItems:'center', justifyContent:'center', flexShrink:0 }}>
            {quality===o.id && <div style={{ width:9, height:9, borderRadius:'50%', background:T.accent }}/>}
          </div>
          <div style={{ flex:1 }}>
            <div style={{ fontSize:13, color:T.text }}>{o.label}</div>
            <div style={{ fontSize:11, color:T.text3, marginTop:2 }}>{o.sub}</div>
          </div>
        </div>
      ))}
    </div>
  );
}

function ConfirmDialog({ title, message, confirmLabel='Delete', onConfirm, onClose }) {
  return (
    <div onClick={onClose} style={{
      position:'absolute', inset:0, background:'rgba(0,0,0,0.6)', backdropFilter:'blur(4px)',
      display:'flex', alignItems:'center', justifyContent:'center', zIndex:200, padding:24,
      animation:'fadeIn 0.18s ease',
    }}>
      <div onClick={e=>e.stopPropagation()} style={{
        width:'100%', maxWidth:300, background:T.bg3, borderRadius:14, border:`1px solid ${T.line2}`,
        overflow:'hidden', animation:'slideUp 0.2s ease',
      }}>
        <div style={{ padding:'20px 20px 16px', textAlign:'center' }}>
          <div style={{ fontSize:15, fontWeight:600, color:T.text, marginBottom:6 }}>{title}</div>
          <div style={{ fontSize:12, color:T.text2, lineHeight:1.4 }}>{message}</div>
        </div>
        <div style={{ display:'flex', borderTop:`1px solid ${T.line}` }}>
          <button onClick={onClose} style={{
            flex:1, padding:'13px', background:'none', border:'none', borderRight:`1px solid ${T.line}`,
            color:T.text, fontSize:14, cursor:'pointer', fontFamily:T.sans,
          }}>Cancel</button>
          <button onClick={()=>{onConfirm&&onConfirm();onClose();}} style={{
            flex:1, padding:'13px', background:'none', border:'none',
            color:'#ef4444', fontSize:14, fontWeight:600, cursor:'pointer', fontFamily:T.sans,
          }}>{confirmLabel}</button>
        </div>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// DOWNLOAD PROGRESS INDICATOR
// ═══════════════════════════════════════════════════════════════
function DownloadIndicator({ state='idle', progress=0, size=14 }) {
  if (state === 'idle') return null;

  if (state === 'queued') {
    return (
      <div style={{ width:size, height:size, borderRadius:'50%',
        border:`2px solid ${T.text3}`, borderTopColor:'transparent',
        animation:'spin 0.8s linear infinite' }}/>
    );
  }
  if (state === 'running') {
    const r = (size-2)/2, c = size/2, circ = 2*Math.PI*r;
    return (
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
        <circle cx={c} cy={c} r={r} fill="none" stroke={T.bg4} strokeWidth="2"/>
        <circle cx={c} cy={c} r={r} fill="none" stroke={T.accent} strokeWidth="2"
          strokeLinecap="round" strokeDasharray={circ}
          strokeDashoffset={circ*(1-progress)} transform={`rotate(-90 ${c} ${c})`}/>
      </svg>
    );
  }
  if (state === 'downloaded') {
    return (
      <svg width={size} height={size} viewBox="0 0 14 14" fill={T.accent}>
        <circle cx="7" cy="7" r="7"/>
        <path d="M4 7l2 2 4-4" fill="none" stroke="#000" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"/>
      </svg>
    );
  }
  if (state === 'failed') {
    return (
      <svg width={size} height={size} viewBox="0 0 14 14" fill="none" stroke="#ef4444" strokeWidth="1.6">
        <circle cx="7" cy="7" r="6"/>
        <path d="M7 4v3M7 9.5v0.5" strokeLinecap="round"/>
      </svg>
    );
  }
  return null;
}

// ═══════════════════════════════════════════════════════════════
// LIBRARY ACTION SHEET (bottom modal)
// ═══════════════════════════════════════════════════════════════
function ActionSheet({ title, items, onClose }) {
  return (
    <div onClick={onClose} style={{
      position:'absolute', inset:0, background:'rgba(0,0,0,0.5)', backdropFilter:'blur(4px)',
      display:'flex', alignItems:'flex-end', justifyContent:'center', zIndex:200,
      animation:'fadeIn 0.18s ease',
    }}>
      <div onClick={e=>e.stopPropagation()} style={{
        width:'100%', background:T.bg2, borderRadius:'16px 16px 0 0',
        borderTop:`1px solid ${T.line2}`, paddingBottom:24, animation:'slideUp 0.22s ease',
      }}>
        <div style={{ padding:'10px 0 6px', display:'flex', justifyContent:'center' }}>
          <div style={{ width:36, height:4, borderRadius:2, background:T.line2 }}/>
        </div>
        {title && (
          <div style={{ padding:'10px 20px 14px', borderBottom:`1px solid ${T.line}`,
            fontSize:13, fontWeight:600, color:T.text, textAlign:'center',
            whiteSpace:'nowrap', overflow:'hidden', textOverflow:'ellipsis' }}>{title}</div>
        )}
        {items.map((it,i)=>(
          <div key={i} onClick={()=>{it.onClick&&it.onClick();onClose();}} style={{
            padding:'14px 20px', display:'flex', alignItems:'center', gap:14, cursor:'pointer',
            borderBottom: i===items.length-1 ? 'none' : `1px solid ${T.line}`,
            color: it.danger ? '#ef4444' : T.text,
          }}>
            <div style={{ width:22, height:22, display:'flex', alignItems:'center', justifyContent:'center', color: it.danger ? '#ef4444' : T.text2 }}>{it.icon}</div>
            <div style={{ fontSize:14, fontFamily:T.sans }}>{it.label}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

// Standard track/album action items
const playIcon  = <svg width="18" height="18" viewBox="0 0 18 18" fill="currentColor"><path d="M4 2l12 7-12 7z"/></svg>;
const nextIcon  = <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><path d="M2 4h8M2 9h8M2 14h5M14 2v8M14 12v4M11 14h6"/></svg>;
const addIcon   = <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><circle cx="9" cy="9" r="7"/><path d="M9 6v6M6 9h6"/></svg>;
const dlIcon    = <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><path d="M9 2v9M5 8l4 4 4-4M3 15h12"/></svg>;
const dlOffIcon = <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><path d="M2 2l14 14M9 2v9M5 8l4 4 4-4M3 15h12"/></svg>;
const folderIcon= <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><path d="M2 4h5l2 2h7v8H2z"/></svg>;

Object.assign(window, { SettingsScreen, DownloadIndicator, ActionSheet, ConfirmDialog,
  playIcon, nextIcon, addIcon, dlIcon, dlOffIcon, folderIcon });

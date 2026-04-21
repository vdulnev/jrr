// ─── DESIGN TOKENS ───────────────────────────────────────────
const T = {
  bg0: '#080809', bg1: '#0e0e10', bg2: '#161618', bg3: '#1e1e21', bg4: '#26262a',
  line: 'rgba(255,255,255,0.06)', line2: 'rgba(255,255,255,0.1)',
  text: '#f0ede8', text2: 'rgba(240,237,232,0.55)', text3: 'rgba(240,237,232,0.3)',
  accent: '#C8922A', accentDim: 'rgba(200,146,42,0.15)',
  mono: "'IBM Plex Mono', monospace", sans: "'Inter', sans-serif",
};

// ─── ALBUM ART PLACEHOLDER ───────────────────────────────────
function AlbumArt({ size=200, style={} }) {
  return (
    <div style={{ width:size, height:size, borderRadius:8, overflow:'hidden', flexShrink:0, ...style }}>
      <svg width={size} height={size} viewBox="0 0 200 200">
        <defs>
          <linearGradient id="ag1" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stopColor="#1a1208"/><stop offset="100%" stopColor="#0e0e10"/>
          </linearGradient>
          <pattern id="stripes" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
            <rect width="4" height="8" fill="rgba(200,146,42,0.04)"/>
          </pattern>
        </defs>
        <rect width="200" height="200" fill="url(#ag1)"/>
        <rect width="200" height="200" fill="url(#stripes)"/>
        <circle cx="100" cy="100" r="72" fill="none" stroke="rgba(200,146,42,0.08)" strokeWidth="1"/>
        <circle cx="100" cy="100" r="50" fill="none" stroke="rgba(200,146,42,0.06)" strokeWidth="1"/>
        <circle cx="100" cy="100" r="28" fill="none" stroke="rgba(200,146,42,0.08)" strokeWidth="1"/>
        <circle cx="100" cy="100" r="8" fill="rgba(200,146,42,0.2)"/>
        <circle cx="100" cy="100" r="3" fill="rgba(200,146,42,0.5)"/>
        <text x="100" y="165" textAnchor="middle" fill="rgba(200,146,42,0.2)" fontSize="8"
          fontFamily="'IBM Plex Mono', monospace" letterSpacing="2">ALBUM ART</text>
      </svg>
    </div>
  );
}

// ─── VU METER ────────────────────────────────────────────────
function VUMeter({ active }) {
  return (
    <div style={{ display:'flex', gap:3, alignItems:'flex-end', height:24 }}>
      {Array.from({length:7}).map((_,i) => (
        <div key={i} style={{
          width:3, borderRadius:2, background:T.accent,
          opacity: active ? 0.9 : 0.2, height: active ? undefined : 4,
          animation: active ? `barAnim ${0.4+i*0.12}s ease-in-out infinite` : 'none',
          animationDelay:`${i*0.08}s`,
        }}/>
      ))}
    </div>
  );
}

// ─── TRANSPORT BUTTON ────────────────────────────────────────
function TransportBtn({ children, size=48, accent=false, onClick, style={} }) {
  const [pressed, setPressed] = React.useState(false);
  return (
    <button onMouseDown={()=>setPressed(true)} onMouseUp={()=>setPressed(false)}
      onMouseLeave={()=>setPressed(false)} onClick={onClick}
      style={{
        width:size, height:size, borderRadius:'50%', border:'none',
        background: accent ? `linear-gradient(135deg,${T.accent},#a07020)` : pressed ? T.bg3 : 'transparent',
        display:'flex', alignItems:'center', justifyContent:'center',
        cursor:'pointer', transition:'all 0.15s',
        transform: pressed ? 'scale(0.93)' : 'scale(1)',
        boxShadow: accent ? `0 4px 20px ${T.accent}66` : 'none',
        color: accent ? '#000' : T.text2, ...style,
      }}>{children}</button>
  );
}

// ─── PROGRESS BAR ────────────────────────────────────────────
function ProgressBar({ progress, onChange }) {
  const ref = React.useRef();
  const [dragging, setDragging] = React.useState(false);
  const calc = e => {
    const r = ref.current.getBoundingClientRect();
    return Math.max(0, Math.min(1, ((e.touches?e.touches[0].clientX:e.clientX)-r.left)/r.width));
  };
  return (
    <div ref={ref} style={{ width:'100%', height:32, display:'flex', alignItems:'center', cursor:'pointer' }}
      onMouseDown={e=>{setDragging(true);onChange(calc(e));}}
      onMouseMove={e=>dragging&&onChange(calc(e))}
      onMouseUp={()=>setDragging(false)} onMouseLeave={()=>setDragging(false)}>
      <div style={{ width:'100%', height:dragging?6:3, borderRadius:3, background:T.bg4, transition:'height 0.15s', position:'relative' }}>
        <div style={{ width:`${progress*100}%`, height:'100%', borderRadius:3, background:`linear-gradient(90deg,${T.accent}cc,${T.accent})` }}/>
        <div style={{ position:'absolute', left:`${progress*100}%`, top:'50%', transform:'translate(-50%,-50%)',
          width:dragging?14:0, height:dragging?14:0, borderRadius:'50%', background:T.accent, transition:'all 0.15s' }}/>
      </div>
    </div>
  );
}

// ─── SUB-SCREEN HEADER ───────────────────────────────────────
function SubScreenHeader({ title, subtitle, onBack, right }) {
  return (
    <div style={{ padding:'56px 20px 16px', flexShrink:0 }}>
      <button onClick={onBack} style={{
        background:'none', border:'none', cursor:'pointer', display:'flex', alignItems:'center',
        gap:6, color:T.accent, fontSize:13, fontWeight:500, padding:0, marginBottom:14,
      }}>
        <svg width="8" height="14" viewBox="0 0 8 14" fill="none" stroke={T.accent} strokeWidth="2" strokeLinecap="round"><path d="M7 1L1 7l6 6"/></svg>
        Back
      </button>
      <div style={{ display:'flex', alignItems:'flex-end', justifyContent:'space-between' }}>
        <div>
          {subtitle && <div style={{ fontFamily:T.mono, fontSize:9, letterSpacing:3, color:T.accent, textTransform:'uppercase', marginBottom:4 }}>{subtitle}</div>}
          <div style={{ fontSize:22, fontWeight:700, color:T.text, letterSpacing:-0.4, lineHeight:1.2 }}>{title}</div>
        </div>
        {right}
      </div>
    </div>
  );
}

// ─── TRACK ROW ───────────────────────────────────────────────
function TrackRow({ track, index, onPlay, expanded, onToggle }) {
  return (
    <div style={{ borderBottom:`1px solid ${T.line}` }}>
      <div onClick={onToggle} style={{ display:'flex', alignItems:'center', gap:14, padding:'10px 20px', cursor:'pointer' }}>
        <div style={{ width:24, textAlign:'center', fontFamily:T.mono, fontSize:11, color:T.text3 }}>{index}</div>
        <div style={{ flex:1 }}>
          <div style={{ fontSize:13, color:T.text, fontWeight:500 }}>{track.title}</div>
          {expanded && <div style={{ fontSize:11, color:T.text3, marginTop:2 }}>{track.artist} · {track.album}</div>}
        </div>
        <div style={{ textAlign:'right', flexShrink:0 }}>
          <div style={{ fontFamily:T.mono, fontSize:10, color:T.text3 }}>{track.duration}</div>
          {expanded && <div style={{ fontFamily:T.mono, fontSize:9, color:`${T.accent}99`, marginTop:2 }}>FLAC</div>}
        </div>
      </div>
      {expanded && (
        <div style={{ padding:'0 20px 10px 58px', display:'flex', gap:8, flexWrap:'wrap' }}>
          <ActionChip label="▶ Play"/>
          <ActionChip label="+ Add to Playing Now"/>
          <ActionChip label="Play Next"/>
        </div>
      )}
    </div>
  );
}

// ─── ALBUM ROW (text list with actions) ──────────────────────
function AlbumRow({ album, onAlbum, onFolder }) {
  const [open, setOpen] = React.useState(false);
  return (
    <div style={{ borderBottom:`1px solid ${T.line}` }}>
      <div style={{ display:'flex', alignItems:'center', gap:14, padding:'12px 20px', cursor:'pointer' }}
        onClick={()=>onAlbum(album)}>
        <AlbumArt size={48} style={{ borderRadius:6, flexShrink:0 }}/>
        <div style={{ flex:1, minWidth:0 }}>
          <div style={{ fontSize:14, fontWeight:500, color:T.text }}>{album.title}</div>
          <div style={{ fontFamily:T.mono, fontSize:10, color:T.text3, marginTop:3 }}>{album.year} · {album.tracks} tracks</div>
        </div>
        <button onClick={e=>{e.stopPropagation();setOpen(o=>!o);}} style={{
          background:'none', border:'none', cursor:'pointer', padding:'4px 8px', color:T.text3,
        }}>
          <svg width="4" height="16" viewBox="0 0 4 16" fill={T.text3}>
            <circle cx="2" cy="2" r="1.5"/><circle cx="2" cy="8" r="1.5"/><circle cx="2" cy="14" r="1.5"/>
          </svg>
        </button>
      </div>
      {open && (
        <div style={{ padding:'0 20px 12px 82px', display:'flex', gap:8, flexWrap:'wrap' }}>
          <ActionChip label="▶ Play"/>
          <ActionChip label="+ Add to Playing Now"/>
          <ActionChip label="Play Next"/>
          <ActionChip label="Open Folder" onClick={()=>{setOpen(false);onFolder&&onFolder(album.folder);}}/>
        </div>
      )}
    </div>
  );
}

// ─── ACTION CHIP ─────────────────────────────────────────────
function ActionChip({ label, onClick }) {
  return (
    <button onClick={onClick} style={{
      height:26, paddingInline:10, borderRadius:13, border:`1px solid ${T.line2}`,
      background:T.bg3, color:T.text2, fontSize:11, fontFamily:T.sans, cursor:'pointer',
    }}>{label}</button>
  );
}

Object.assign(window, { T, AlbumArt, VUMeter, TransportBtn, ProgressBar, SubScreenHeader, TrackRow, AlbumRow, ActionChip });

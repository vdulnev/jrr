// ═══════════════════════════════════════════════════════════════
// SERVER SETUP SCREEN
// ═══════════════════════════════════════════════════════════════
function ServerSetupScreen({ onConnect }) {
  const [host, setHost] = React.useState('192.168.1.10');
  const [port, setPort] = React.useState('52199');
  const [username, setUsername] = React.useState('');
  const [password, setPassword] = React.useState('');
  const [selectedServer, setSelectedServer] = React.useState(SAVED_SERVERS[0].id);

  const inputStyle = {
    width:'100%', height:44, borderRadius:10, border:`1px solid ${T.line2}`,
    background:T.bg2, color:T.text, fontSize:14, padding:'0 14px',
    outline:'none', fontFamily:T.sans,
  };
  const labelStyle = { fontSize:11, color:T.text3, marginBottom:6, display:'block', letterSpacing:0.3, textTransform:'uppercase', fontFamily:T.mono };

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100%', animation:'fadeIn 0.3s ease', overflowY:'auto', paddingBottom:40 }}>
      {/* Logo / header */}
      <div style={{ padding:'64px 24px 32px', textAlign:'center' }}>
        <div style={{ width:56, height:56, borderRadius:14, background:T.accentDim, border:`1px solid ${T.accent}44`,
          display:'flex', alignItems:'center', justifyContent:'center', margin:'0 auto 16px' }}>
          <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
            <circle cx="14" cy="14" r="11" stroke={T.accent} strokeWidth="1.5"/>
            <circle cx="14" cy="14" r="5" fill={T.accent} opacity="0.4"/>
            <circle cx="14" cy="14" r="2" fill={T.accent}/>
            <path d="M14 3v4M14 21v4M3 14h4M21 14h4" stroke={T.accent} strokeWidth="1.5" strokeLinecap="round"/>
          </svg>
        </div>
        <div style={{ fontSize:22, fontWeight:700, color:T.text, letterSpacing:-0.5 }}>JRiver Remote</div>
        <div style={{ fontSize:12, color:T.text3, marginTop:4 }}>Connect to your media server</div>
      </div>

      {/* Manual entry */}
      <div style={{ padding:'0 20px', display:'flex', flexDirection:'column', gap:16 }}>

        <div style={{ display:'flex', gap:10 }}>
          <div style={{ flex:1 }}>
            <label style={labelStyle}>Host</label>
            <input value={host} onChange={e=>setHost(e.target.value)} placeholder="192.168.1.10" style={inputStyle}/>
          </div>
          <div style={{ width:90 }}>
            <label style={labelStyle}>Port</label>
            <input value={port} onChange={e=>setPort(e.target.value)} placeholder="52199" style={inputStyle}/>
          </div>
        </div>
        <div>
          <label style={labelStyle}>Username (optional)</label>
          <input value={username} onChange={e=>setUsername(e.target.value)} placeholder="Leave blank if none" style={inputStyle}/>
        </div>
        <div>
          <label style={labelStyle}>Password (optional)</label>
          <input value={password} onChange={e=>setPassword(e.target.value)} type="password" placeholder="Leave blank if none" style={inputStyle}/>
        </div>

        <button onClick={() => onConnect({ host, port, username, password })} style={{
          height:50, borderRadius:12, border:'none',
          background:`linear-gradient(135deg, ${T.accent}, #a07020)`,
          color:'#000', fontSize:15, fontWeight:600, fontFamily:T.sans, cursor:'pointer',
          boxShadow:`0 4px 20px ${T.accent}44`, marginTop:4,
        }}>Connect</button>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// CONNECTING SCREEN
// ═══════════════════════════════════════════════════════════════
function ConnectingScreen({ host, onSuccess, onCancel }) {
  const [phase, setPhase] = React.useState('connecting'); // connecting | authenticating | done
  const [error, setError] = React.useState(null);

  React.useEffect(() => {
    const t1 = setTimeout(() => setPhase('authenticating'), 1200);
    const t2 = setTimeout(() => { setPhase('done'); setTimeout(onSuccess, 600); }, 2400);
    return () => { clearTimeout(t1); clearTimeout(t2); };
  }, []);

  const phaseLabel = { connecting:'Connecting…', authenticating:'Authenticating…', done:'Connected' }[phase];

  return (
    <div style={{ display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', height:'100%', gap:24, animation:'fadeIn 0.3s ease' }}>
      <div style={{ position:'relative', width:72, height:72 }}>
        {phase !== 'done' ? (
          <svg width="72" height="72" viewBox="0 0 72 72">
            <circle cx="36" cy="36" r="30" fill="none" stroke={T.bg3} strokeWidth="3"/>
            <circle cx="36" cy="36" r="30" fill="none" stroke={T.accent} strokeWidth="3"
              strokeDasharray="54 135" strokeLinecap="round"
              style={{ transformOrigin:'center', animation:'spin 1s linear infinite' }}/>
          </svg>
        ) : (
          <svg width="72" height="72" viewBox="0 0 72 72" style={{ animation:'fadeIn 0.3s ease' }}>
            <circle cx="36" cy="36" r="30" fill={T.accentDim} stroke={T.accent} strokeWidth="1.5"/>
            <path d="M22 36l9 9 19-19" fill="none" stroke={T.accent} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        )}
      </div>
      <div style={{ textAlign:'center' }}>
        <div style={{ fontSize:15, fontWeight:600, color:T.text, marginBottom:6 }}>{phaseLabel}</div>
        <div style={{ fontFamily:T.mono, fontSize:11, color:T.text3 }}>{host}</div>
      </div>

    </div>
  );
}

Object.assign(window, { ServerSetupScreen, ConnectingScreen });

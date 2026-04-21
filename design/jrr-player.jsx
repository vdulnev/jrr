// ─── VOLUME KNOB ─────────────────────────────────────────────
function VolumeKnob({ value, onChange, size=100 }) {
  const minAngle=-135, maxAngle=135;
  const angle = minAngle+(value/100)*(maxAngle-minAngle);
  const dragging=React.useRef(false), startY=React.useRef(0), startVal=React.useRef(0);

  const onMD=e=>{dragging.current=true;startY.current=e.clientY;startVal.current=value;};
  const onMM=e=>{if(!dragging.current)return;const dy=startY.current-e.clientY;onChange(Math.max(0,Math.min(100,startVal.current+dy*0.8)));};
  const onMU=()=>{dragging.current=false;};

  React.useEffect(()=>{
    window.addEventListener('mousemove',onMM);window.addEventListener('mouseup',onMU);
    return()=>{window.removeEventListener('mousemove',onMM);window.removeEventListener('mouseup',onMU);};
  },[value]);

  const r=size/2,cx=r,cy=r,knobR=r*0.72,arcR=r*0.88;
  const pxy=(a,rad)=>{const ang=(a-90)*Math.PI/180;return{x:cx+rad*Math.cos(ang),y:cy+rad*Math.sin(ang)};};
  const arc=(rad,s,e)=>{const sv=pxy(s,rad),ev=pxy(e,rad),large=Math.abs(e-s)>180?1:0;return `M ${sv.x} ${sv.y} A ${rad} ${rad} 0 ${large} 1 ${ev.x} ${ev.y}`;};
  const dot=pxy(angle,knobR*0.65);

  return (
    <svg width={size} height={size} style={{cursor:'ns-resize',userSelect:'none'}} onMouseDown={onMD}>
      <path d={arc(arcR,minAngle,maxAngle)} fill="none" stroke={T.bg4} strokeWidth="5" strokeLinecap="round"/>
      <path d={arc(arcR,minAngle,angle)} fill="none" stroke={T.accent} strokeWidth="5" strokeLinecap="round"/>
      <circle cx={cx} cy={cy} r={knobR} fill={T.bg3}/>
      <circle cx={cx} cy={cy} r={knobR} fill="none" stroke={T.line2} strokeWidth="1"/>
      <ellipse cx={cx-knobR*0.2} cy={cy-knobR*0.3} rx={knobR*0.3} ry={knobR*0.15}
        fill="rgba(255,255,255,0.04)" transform={`rotate(-30,${cx},${cy})`}/>
      <circle cx={dot.x} cy={dot.y} r={4} fill={T.accent}/>
    </svg>
  );
}

// ═══════════════════════════════════════════════════════════════
// NOW PLAYING SCREEN
// ═══════════════════════════════════════════════════════════════
function NowPlayingScreen({ tweaks, playing, setPlaying }) {
  const [progress, setProgress] = React.useState(0.35);
  const [shuffle, setShuffle] = React.useState(false);
  const [repeat, setRepeat] = React.useState(false);
  const track = TRACKS[0];

  React.useEffect(()=>{
    if(!playing)return;
    const id=setInterval(()=>setProgress(p=>p>=1?0:p+0.001),300);
    return()=>clearInterval(id);
  },[playing]);

  const elapsed=Math.floor(progress*562);
  const fmt=s=>`${Math.floor(s/60)}:${String(s%60).padStart(2,'0')}`;

  return (
    <div style={{display:'flex',flexDirection:'column',height:'100%',padding:'0 0 88px',animation:'fadeIn 0.3s ease'}}>
      <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',padding:'56px 20px 16px'}}>
        <div>
          <div style={{fontFamily:T.mono,fontSize:9,letterSpacing:3,color:T.accent,textTransform:'uppercase',marginBottom:4}}>Now Playing</div>
          <div style={{fontSize:11,color:T.text3}}>{ZONES[0].name} · FLAC 24/192</div>
        </div>
      </div>

      <div style={{flex:1,display:'flex',alignItems:'center',justifyContent:'center',padding:'8px 24px'}}>
        <div style={{width:'100%',aspectRatio:'1/1',maxWidth:280,maxHeight:280,borderRadius:12,overflow:'hidden',
          boxShadow:`0 16px 60px rgba(0,0,0,0.8),0 0 0 1px ${T.line2}`,position:'relative'}}>
          <AlbumArt size={280} style={{width:'100%',height:'100%',borderRadius:0}}/>
          {playing&&<div style={{position:'absolute',inset:0,background:'radial-gradient(ellipse at 30% 30%,rgba(200,146,42,0.07),transparent 60%)',pointerEvents:'none'}}/>}
        </div>
      </div>

      <div style={{padding:'0 24px'}}>
        <div style={{marginBottom:4}}>
          <div style={{fontSize:20,fontWeight:600,color:T.text,lineHeight:1.2,letterSpacing:-0.3}}>{track.title}</div>
          <div style={{fontSize:14,color:T.text2,marginTop:3}}>{track.artist}</div>
          <div style={{fontSize:11,color:T.text3,marginTop:2,fontFamily:T.mono}}>{track.album} · {track.year}</div>
        </div>
        <div style={{marginTop:16}}>
          <ProgressBar progress={progress} onChange={setProgress}/>
          <div style={{display:'flex',justifyContent:'space-between',marginTop:2}}>
            <span style={{fontFamily:T.mono,fontSize:10,color:T.text3}}>{fmt(elapsed)}</span>
            <span style={{fontFamily:T.mono,fontSize:10,color:T.text3}}>−{fmt(562-elapsed)}</span>
          </div>
        </div>
        <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',marginTop:20}}>
          <TransportBtn size={40} onClick={()=>setShuffle(s=>!s)} style={{color:shuffle?T.accent:T.text3}}>
            <svg width="18" height="14" viewBox="0 0 18 14" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round">
              <path d="M1 1h4l8 12h4M13 1h4l-4 5M17 8l-4 5"/>
            </svg>
          </TransportBtn>
          <TransportBtn size={44}>
            <svg width="20" height="18" viewBox="0 0 20 18" fill="currentColor"><path d="M19 1v16l-9-8L19 1zM10 1v16l-9-8L10 1z"/></svg>
          </TransportBtn>
          <TransportBtn size={60} accent onClick={()=>setPlaying(p=>!p)}>
            {playing
              ? <svg width="20" height="22" viewBox="0 0 20 22" fill="currentColor"><rect x="2" y="1" width="6" height="20" rx="2"/><rect x="12" y="1" width="6" height="20" rx="2"/></svg>
              : <svg width="22" height="22" viewBox="0 0 22 22" fill="currentColor"><path d="M4 2l16 9-16 9z"/></svg>
            }
          </TransportBtn>
          <TransportBtn size={44}>
            <svg width="20" height="18" viewBox="0 0 20 18" fill="currentColor"><path d="M10 1v16l9-8L10 1zM1 1v16l9-8L1 1z"/></svg>
          </TransportBtn>
          <TransportBtn size={40} onClick={()=>setRepeat(r=>!r)} style={{color:repeat?T.accent:T.text3}}>
            <svg width="18" height="16" viewBox="0 0 18 16" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
              <path d="M1 5V3a2 2 0 012-2h12a2 2 0 012 2v10a2 2 0 01-2 2H3a2 2 0 01-2-2v-2"/>
              <path d="M3 8H1m2 0L1 6m2 2L1 10"/>
            </svg>
          </TransportBtn>
        </div>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// QUEUE SCREEN
// ═══════════════════════════════════════════════════════════════
function QueueScreen() {
  const [queue,setQueue]=React.useState(QUEUE);
  return (
    <div style={{display:'flex',flexDirection:'column',height:'100%',animation:'fadeIn 0.3s ease'}}>
      <div style={{padding:'56px 20px 16px'}}>
        <div style={{fontFamily:T.mono,fontSize:9,letterSpacing:3,color:T.accent,textTransform:'uppercase',marginBottom:6}}>Playback</div>
        <div style={{display:'flex',alignItems:'flex-end',justifyContent:'space-between'}}>
          <div style={{fontSize:24,fontWeight:700,color:T.text,letterSpacing:-0.5}}>Queue</div>
          <div style={{fontFamily:T.mono,fontSize:10,color:T.text3,marginBottom:3}}>{queue.length} tracks</div>
        </div>
      </div>
      <div style={{padding:'0 20px 8px'}}>
        <div style={{fontSize:11,fontWeight:600,color:T.text3,letterSpacing:1,textTransform:'uppercase'}}>Up Next</div>
      </div>
      <div style={{flex:1,overflowY:'auto',paddingBottom:148}}>
        {queue.map((track,i)=>(
          <div key={track.id} style={{display:'flex',alignItems:'center',gap:14,padding:'12px 20px',
            borderBottom:`1px solid ${T.line}`,background:track.current?T.accentDim:'transparent',position:'relative'}}>
            {track.current&&<div style={{position:'absolute',left:0,top:0,bottom:0,width:2.5,background:T.accent,borderRadius:'0 2px 2px 0'}}/>}
            {track.current?<VUMeter active={true}/>:<div style={{width:24,textAlign:'center',fontFamily:T.mono,fontSize:11,color:T.text3,flexShrink:0}}>{i+1}</div>}
            <div style={{flex:1}}>
              <div style={{fontSize:14,color:T.text,fontWeight:track.current?600:400}}>{track.title}</div>
              <div style={{fontSize:11,color:T.text3,marginTop:1}}>{track.artist}</div>
            </div>
            <div style={{fontFamily:T.mono,fontSize:11,color:T.text3}}>{track.duration}</div>
            <div style={{cursor:'grab',padding:4}}>
              <svg width="16" height="12" viewBox="0 0 16 12">
                <rect x="0" y="0" width="16" height="1.5" rx="0.75" fill={T.text3}/>
                <rect x="0" y="5" width="16" height="1.5" rx="0.75" fill={T.text3}/>
                <rect x="0" y="10" width="16" height="1.5" rx="0.75" fill={T.text3}/>
              </svg>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// ZONES SCREEN
// ═══════════════════════════════════════════════════════════════
function ZonesScreen() {
  const [zones,setZones]=React.useState(ZONES);
  const [masterVol,setMasterVol]=React.useState(72);
  const activateZone=id=>setZones(zs=>zs.map(z=>({...z,active:z.id===id})));
  const setZoneVol=(id,v)=>setZones(zs=>zs.map(z=>z.id===id?{...z,volume:Math.round(v)}:z));

  return (
    <div style={{display:'flex',flexDirection:'column',height:'100%',animation:'fadeIn 0.3s ease'}}>
      <div style={{padding:'56px 20px 20px'}}>
        <div style={{fontFamily:T.mono,fontSize:9,letterSpacing:3,color:T.accent,textTransform:'uppercase',marginBottom:6}}>Output</div>
        <div style={{fontSize:24,fontWeight:700,color:T.text,letterSpacing:-0.5}}>Volume & Zones</div>
      </div>
      <div style={{display:'flex',flexDirection:'column',alignItems:'center',paddingTop:8,paddingBottom:24}}>
        <VolumeKnob value={masterVol} onChange={setMasterVol} size={140}/>
        <div style={{marginTop:8,textAlign:'center'}}>
          <div style={{fontFamily:T.mono,fontSize:28,fontWeight:500,color:T.text,lineHeight:1}}>{Math.round(masterVol)}</div>
          <div style={{fontFamily:T.mono,fontSize:10,color:T.text3,marginTop:4,letterSpacing:2,textTransform:'uppercase'}}>Master Volume</div>
        </div>
        <div style={{display:'flex',gap:12,marginTop:16}}>
          {[0,25,50,75,100].map(v=>(
            <button key={v} onClick={()=>setMasterVol(v)} style={{
              height:28,paddingInline:10,borderRadius:6,border:`1px solid ${T.line2}`,
              background:Math.round(masterVol)===v?T.accentDim:T.bg2,
              color:Math.round(masterVol)===v?T.accent:T.text3,
              fontSize:11,fontFamily:T.mono,cursor:'pointer',transition:'all 0.2s',
            }}>{v}</button>
          ))}
        </div>
      </div>
      <div style={{height:1,background:T.line,marginInline:20,marginBottom:16}}/>
      <div style={{padding:'0 20px 4px'}}>
        <div style={{fontSize:11,fontWeight:600,color:T.text3,letterSpacing:1,textTransform:'uppercase',marginBottom:12}}>Zones</div>
      </div>
      <div style={{flex:1,overflowY:'auto',paddingBottom:148,paddingInline:16}}>
        {zones.map(zone=>(
          <div key={zone.id} onClick={()=>activateZone(zone.id)} style={{
            background:zone.active?T.accentDim:T.bg2,
            border:`1px solid ${zone.active?T.accent+'44':T.line}`,
            borderRadius:12,marginBottom:10,padding:'14px 16px',cursor:'pointer',transition:'all 0.2s',
          }}>
            <div style={{display:'flex',alignItems:'center',gap:10,marginBottom:zone.active?12:0}}>
              {zone.active&&<div style={{width:7,height:7,borderRadius:'50%',background:T.accent,flexShrink:0,boxShadow:`0 0 6px ${T.accent}`}}/>}
              <div style={{flex:1}}>
                <div style={{fontSize:14,fontWeight:zone.active?600:400,color:T.text}}>{zone.name}</div>
                <div style={{fontSize:11,color:T.text3,marginTop:2}}>{zone.device}</div>
              </div>
              <div style={{fontFamily:T.mono,fontSize:16,color:zone.active?T.accent:T.text3,fontWeight:500}}>{zone.volume}</div>
            </div>
            {zone.active&&(
              <div style={{position:'relative',height:4,borderRadius:2,background:T.bg4,cursor:'pointer'}}
                onClick={e=>{e.stopPropagation();const r=e.currentTarget.getBoundingClientRect();setZoneVol(zone.id,((e.clientX-r.left)/r.width)*100);}}>
                <div style={{width:`${zone.volume}%`,height:'100%',borderRadius:2,background:`linear-gradient(90deg,${T.accent}88,${T.accent})`}}/>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// MINI PLAYER
// ═══════════════════════════════════════════════════════════════
function MiniPlayer({ onTap, playing, setPlaying }) {
  const [progress,setProgress]=React.useState(0.35);
  React.useEffect(()=>{
    if(!playing)return;
    const id=setInterval(()=>setProgress(p=>p>=1?0:p+0.001),300);
    return()=>clearInterval(id);
  },[playing]);

  return (
    <div onClick={onTap} style={{position:'absolute',bottom:82,left:10,right:10,
      background:T.bg3,borderRadius:14,border:`1px solid ${T.line2}`,
      boxShadow:'0 8px 32px rgba(0,0,0,0.6)',overflow:'hidden',cursor:'pointer',zIndex:99}}>
      <div style={{height:2,background:T.bg4}}><div style={{width:`${progress*100}%`,height:'100%',background:T.accent}}/></div>
      <div style={{display:'flex',alignItems:'center',gap:12,padding:'10px 14px'}}>
        <div style={{width:40,height:40,borderRadius:7,overflow:'hidden',flexShrink:0}}>
          <AlbumArt size={40} style={{width:40,height:40,borderRadius:0}}/>
        </div>
        <div style={{flex:1,minWidth:0}}>
          <div style={{fontSize:13,fontWeight:600,color:T.text,whiteSpace:'nowrap',overflow:'hidden',textOverflow:'ellipsis'}}>So What</div>
          <div style={{fontSize:11,color:T.text3,marginTop:1}}>Miles Davis</div>
        </div>
        <div style={{display:'flex',alignItems:'center',gap:4}} onClick={e=>e.stopPropagation()}>
          <TransportBtn size={36} onClick={()=>setPlaying(p=>!p)}>
            {playing
              ? <svg width="12" height="14" viewBox="0 0 12 14" fill={T.text2}><rect x="0" y="0" width="4" height="14" rx="1.5"/><rect x="8" y="0" width="4" height="14" rx="1.5"/></svg>
              : <svg width="14" height="14" viewBox="0 0 14 14" fill={T.text2}><path d="M2 1l11 6-11 6z"/></svg>
            }
          </TransportBtn>
          <TransportBtn size={36}>
            <svg width="16" height="14" viewBox="0 0 16 14" fill={T.text2}><path d="M8 1v12l7-6L8 1zM1 1v12l7-6L1 1z"/></svg>
          </TransportBtn>
        </div>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// TAB BAR
// ═══════════════════════════════════════════════════════════════
function TabBar({ active, onChange }) {
  const tabs = [
    { id:'now', label:'Playing', icon:c=>(
      <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
        <circle cx="11" cy="11" r="9" stroke={c} strokeWidth="1.6"/>
        <circle cx="11" cy="11" r="3" fill={c}/>
        <circle cx="11" cy="11" r="6" stroke={c} strokeWidth="1" strokeDasharray="2 2"/>
      </svg>
    )},
    { id:'queue', label:'Queue', icon:c=>(
      <svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round">
        <path d="M2 6h18M2 11h14M2 16h10"/>
        <circle cx="18" cy="15" r="3.5"/>
        <path d="M18 13v2.3l1.5 1" strokeWidth="1.4"/>
      </svg>
    )},
    { id:'library', label:'Library', icon:c=>(
      <svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round">
        <rect x="2" y="3" width="5" height="16" rx="1.5"/>
        <rect x="9" y="3" width="5" height="16" rx="1.5"/>
        <path d="M17 4l2 14"/>
      </svg>
    )},
    { id:'zones', label:'Zones', icon:c=>(
      <svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round">
        <circle cx="6" cy="11" r="3"/><circle cx="16" cy="11" r="3"/>
        <path d="M9 11h4M1 11h2M17 11h2"/>
        <path d="M6 5v3M6 13v3M16 5v3M16 13v3" strokeWidth="1.2" opacity="0.5"/>
      </svg>
    )},
  ];
  return (
    <div style={{position:'absolute',bottom:0,left:0,right:0,height:82,borderTop:`1px solid ${T.line}`,
      background:`${T.bg1}f0`,backdropFilter:'blur(20px)',display:'flex',paddingBottom:20,zIndex:100}}>
      {tabs.map(tab=>{
        const isActive=active===tab.id;
        const color=isActive?T.accent:T.text3;
        return (
          <button key={tab.id} onClick={()=>onChange(tab.id)} style={{
            flex:1,border:'none',background:'none',cursor:'pointer',
            display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center',
            gap:4,transition:'all 0.2s',transform:isActive?'translateY(-1px)':'none',
          }}>
            {tab.icon(color)}
            <span style={{fontFamily:T.sans,fontSize:9,color,fontWeight:isActive?600:400,letterSpacing:0.3,textTransform:'uppercase'}}>
              {tab.label}
            </span>
          </button>
        );
      })}
    </div>
  );
}

Object.assign(window, { NowPlayingScreen, QueueScreen, ZonesScreen, MiniPlayer, TabBar, VolumeKnob });

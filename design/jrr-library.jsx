// ═══════════════════════════════════════════════════════════════
// ALBUM DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════
function AlbumDetailScreen({ album, onBack, onFolder }) {
  const tracks = TRACKS.filter(t => t.album === album.title);
  const [expanded, setExpanded] = React.useState(null);

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100%', animation:'fadeIn 0.3s ease' }}>
      <SubScreenHeader title={album.title} subtitle={album.artist} onBack={onBack}
        right={<div style={{ fontFamily:T.mono, fontSize:10, color:T.text3 }}>{album.year} · {album.tracks} tracks</div>}/>

      {/* Art + meta */}
      <div style={{ display:'flex', gap:16, padding:'0 20px 20px', alignItems:'center' }}>
        <AlbumArt size={88} style={{ borderRadius:8, flexShrink:0 }}/>
        <div>
          <div style={{ fontSize:13, color:T.text2 }}>{album.artist}</div>
          <div style={{ fontFamily:T.mono, fontSize:10, color:T.text3, marginTop:4 }}>FLAC 24/192 · Jazz</div>
          <div style={{ fontFamily:T.mono, fontSize:10, color:T.text3, marginTop:2, wordBreak:'break-all' }}>{album.folder}</div>
          <div style={{ display:'flex', gap:8, marginTop:10 }}>
            <ActionChip label="▶ Play All"/>
            <ActionChip label="+ Queue All"/>
            <ActionChip label="Folder" onClick={()=>onFolder&&onFolder(album.folder)}/>
          </div>
        </div>
      </div>

      <div style={{ height:1, background:T.line, marginInline:20, marginBottom:4 }}/>

      {/* Track list */}
      <div style={{ flex:1, overflowY:'auto', paddingBottom:88 }}>
        {(tracks.length ? tracks : TRACKS.slice(0,5)).map((track, i) => (
          <TrackRow key={track.id} track={track} index={i+1}
            expanded={expanded===track.id} onToggle={()=>setExpanded(expanded===track.id?null:track.id)}/>
        ))}
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// ARTIST ALBUMS SCREEN
// ═══════════════════════════════════════════════════════════════
function ArtistAlbumsScreen({ artist, onBack, onAlbum, onFolder }) {
  const albums = ALBUMS.filter(a => a.artist === artist);
  const display = albums.length ? albums : ALBUMS.slice(0,3);
  const [filter, setFilter] = React.useState('');
  const filtered = display.filter(a => a.title.toLowerCase().includes(filter.toLowerCase()));

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100%', animation:'fadeIn 0.3s ease' }}>
      <SubScreenHeader title={artist} subtitle="Artist" onBack={onBack}
        right={<div style={{ fontFamily:T.mono, fontSize:10, color:T.text3 }}>{display.length} albums</div>}/>

      {/* Filter */}
      <div style={{ position:'relative', padding:'0 20px 12px' }}>
        <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={T.text3} strokeWidth="1.5"
          style={{ position:'absolute', left:32, top:'50%', transform:'translateY(-50%)' }}>
          <circle cx="6" cy="6" r="5"/><path d="M11 11l2 2" strokeLinecap="round"/>
        </svg>
        <input value={filter} onChange={e=>setFilter(e.target.value)} placeholder="Filter albums…"
          style={{ width:'100%', height:36, borderRadius:10, border:`1px solid ${T.line2}`,
            background:T.bg2, color:T.text, fontSize:13, paddingLeft:34, outline:'none', fontFamily:T.sans }}/>
      </div>

      <div style={{ flex:1, overflowY:'auto', paddingBottom:88 }}>
        {filtered.map(album => (
          <AlbumRow key={album.id} album={album} onAlbum={onAlbum}
            onFolder={folder=>onFolder&&onFolder(folder)}/>
        ))}
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// RANDOM ALBUMS SCREEN
// ═══════════════════════════════════════════════════════════════
function RandomAlbumsScreen({ onBack, onAlbum, onFolder, embedded }) {
  const [albums, setAlbums] = React.useState([...ALBUMS].sort(()=>Math.random()-0.5).slice(0,10));

  const content = (
    <div>
      {albums.map(album => (
        <AlbumRow key={album.id} album={album} onAlbum={onAlbum} onFolder={onFolder}/>
      ))}
    </div>
  );

  if (embedded) return (
    <div>
      <div style={{ display:'flex', justifyContent:'flex-end', padding:'8px 16px 0' }}>
        <button onClick={()=>setAlbums([...ALBUMS].sort(()=>Math.random()-0.5).slice(0,10))}
          style={{ background:'none', border:`1px solid ${T.line2}`, borderRadius:8, color:T.accent,
            fontSize:12, fontFamily:T.sans, cursor:'pointer', padding:'4px 10px' }}>Shuffle</button>
      </div>
      {content}
    </div>
  );

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100%', animation:'fadeIn 0.3s ease' }}>
      <SubScreenHeader title="Random Albums" subtitle="Library" onBack={onBack}
        right={
          <button onClick={()=>setAlbums([...ALBUMS].sort(()=>Math.random()-0.5).slice(0,10))}
            style={{ background:'none', border:`1px solid ${T.line2}`, borderRadius:8, color:T.accent,
              fontSize:12, fontFamily:T.sans, cursor:'pointer', padding:'4px 10px' }}>Shuffle</button>
        }/>
      <div style={{ flex:1, overflowY:'auto', paddingBottom:88 }}>{content}</div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// FOLDER TRACKS SCREEN
// ═══════════════════════════════════════════════════════════════
function FolderTracksScreen({ folder, onBack }) {
  const parts = folder.split('/').filter(Boolean);
  const [historyStack, setHistoryStack] = React.useState([folder]);
  const currentFolder = historyStack[historyStack.length-1];
  const currentParts = currentFolder.split('/').filter(Boolean);

  const tracks = TRACKS.filter(t => t.path && t.path.startsWith(currentFolder));
  const display = tracks.length ? tracks : TRACKS.slice(0,5);
  const [expanded, setExpanded] = React.useState(null);

  const canGoUp = currentParts.length > 1;
  const canGoDown = historyStack.length > 1;

  const goUp = () => {
    const up = '/'+currentParts.slice(0,-1).join('/');
    setHistoryStack(s=>[...s, up]);
  };
  const goDown = () => setHistoryStack(s=>s.slice(0,-1));

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100%', animation:'fadeIn 0.3s ease' }}>
      <SubScreenHeader title={currentParts[currentParts.length-1]||'Root'} subtitle="Folder" onBack={onBack}/>

      {/* Path + nav */}
      <div style={{ padding:'0 20px 12px', display:'flex', alignItems:'center', gap:8 }}>
        <div style={{ flex:1, fontFamily:T.mono, fontSize:10, color:T.text3, overflow:'hidden', textOverflow:'ellipsis', whiteSpace:'nowrap' }}>
          {currentFolder}
        </div>
        <button onClick={goDown} disabled={!canGoDown}
          style={{ background:'none', border:`1px solid ${T.line2}`, borderRadius:6, color: canGoDown?T.accent:T.text3,
            fontSize:11, cursor:canGoDown?'pointer':'default', padding:'4px 8px', fontFamily:T.mono }}>↓</button>
        <button onClick={goUp} disabled={!canGoUp}
          style={{ background:'none', border:`1px solid ${T.line2}`, borderRadius:6, color: canGoUp?T.accent:T.text3,
            fontSize:11, cursor:canGoUp?'pointer':'default', padding:'4px 8px', fontFamily:T.mono }}>↑</button>
      </div>
      <div style={{ height:1, background:T.line, marginInline:20, marginBottom:4 }}/>

      <div style={{ flex:1, overflowY:'auto', paddingBottom:88 }}>
        {display.map((track,i) => (
          <TrackRow key={track.id} track={track} index={i+1}
            expanded={expanded===track.id} onToggle={()=>setExpanded(expanded===track.id?null:track.id)}/>
        ))}
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// BROWSE FILES SCREEN (leaf node)
// ═══════════════════════════════════════════════════════════════
function BrowseFilesScreen({ node, onBack }) {
  const [grouped, setGrouped] = React.useState(false);
  const [expanded, setExpanded] = React.useState(null);
  const tracks = TRACKS.slice(0,5); // demo tracks for leaf node

  // Group by artist → album
  const groups = tracks.reduce((acc,t) => {
    const k = `${t.artist}|||${t.album}`;
    if (!acc[k]) acc[k]={ artist:t.artist, album:t.album, tracks:[] };
    acc[k].tracks.push(t);
    return acc;
  }, {});

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100%', animation:'fadeIn 0.3s ease' }}>
      <SubScreenHeader title={node.name} subtitle="Browse" onBack={onBack}
        right={
          <div style={{ display:'flex', gap:4, background:T.bg2, borderRadius:8, padding:3 }}>
            {['Flat','Grouped'].map(m => (
              <button key={m} onClick={()=>setGrouped(m==='Grouped')} style={{
                height:26, paddingInline:10, borderRadius:6, border:'none', cursor:'pointer',
                fontSize:11, fontFamily:T.sans,
                background: (grouped===(m==='Grouped')) ? T.bg4 : 'transparent',
                color: (grouped===(m==='Grouped')) ? T.text : T.text3,
              }}>{m}</button>
            ))}
          </div>
        }/>

      <div style={{ flex:1, overflowY:'auto', paddingBottom:88 }}>
        {!grouped ? (
          // Flat list
          tracks.map((t,i) => (
            <TrackRow key={t.id} track={t} index={i+1}
              expanded={expanded===t.id} onToggle={()=>setExpanded(expanded===t.id?null:t.id)}/>
          ))
        ) : (
          // Grouped by artist → album
          Object.values(groups).map(g => (
            <div key={`${g.artist}${g.album}`} style={{ marginBottom:4 }}>
              {/* Artist/album header */}
              <div style={{ padding:'10px 20px 8px', background:T.bg2 }}>
                <div style={{ display:'flex', alignItems:'center', justifyContent:'space-between' }}>
                  <div>
                    <div style={{ fontSize:12, fontWeight:600, color:T.accent }}>{g.artist}</div>
                    <div style={{ fontSize:11, color:T.text2, marginTop:1 }}>{g.album}</div>
                  </div>
                  <div style={{ display:'flex', gap:6 }}>
                    <ActionChip label="▶ Play"/>
                    <ActionChip label="+ Queue"/>
                  </div>
                </div>
              </div>
              {g.tracks.map((t,i) => (
                <TrackRow key={t.id} track={t} index={i+1}
                  expanded={expanded===t.id} onToggle={()=>setExpanded(expanded===t.id?null:t.id)}/>
              ))}
            </div>
          ))
        )}
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// BROWSE SCREEN (tree navigation)
// ═══════════════════════════════════════════════════════════════
function BrowseScreen({ onBack, embedded }) {
  const [browseStack, setBrowseStack] = React.useState([{ node:{id:'-1',name:'Browse'}, children:BROWSE_TREE }]);
  const [leafNode, setLeafNode] = React.useState(null);
  const current = browseStack[browseStack.length-1];

  const openNode = (node) => {
    if (!node.children || node.children.length === 0) { setLeafNode(node); return; }
    setBrowseStack(s => [...s, { node, children: node.children }]);
  };

  const handleBack = () => {
    if (leafNode) { setLeafNode(null); return; }
    if (browseStack.length > 1) setBrowseStack(s=>s.slice(0,-1));
    else if (onBack) onBack();
  };

  if (leafNode) return <BrowseFilesScreen node={leafNode} onBack={()=>setLeafNode(null)}/>;

  const nodeList = (
    <div>
      {/* Breadcrumb */}
      {browseStack.length > 1 && (
        <div style={{ display:'flex', alignItems:'center', gap:4, padding:'8px 20px 12px', overflowX:'auto' }}>
          {browseStack.map((b,i) => (
            <React.Fragment key={i}>
              {i>0 && <svg width="5" height="8" viewBox="0 0 5 8" fill="none"><path d="M1 1l3 3-3 3" stroke={T.text3} strokeWidth="1.2" strokeLinecap="round"/></svg>}
              <button onClick={()=>setBrowseStack(s=>s.slice(0,i+1))} style={{
                background:'none', border:'none', cursor: i<browseStack.length-1?'pointer':'default',
                fontFamily:T.mono, fontSize:10, color: i<browseStack.length-1?T.text3:T.accent, padding:0, whiteSpace:'nowrap',
              }}>{b.node.name}</button>
            </React.Fragment>
          ))}
        </div>
      )}
      {current.children.map(node => {
        const isLeaf = !node.children || node.children.length===0;
        return (
          <div key={node.id} onClick={()=>openNode(node)}
            style={{ display:'flex', alignItems:'center', gap:14, padding:'14px 20px', borderBottom:`1px solid ${T.line}`, cursor:'pointer' }}>
            <div style={{ width:36, height:36, borderRadius:9, background:T.bg3, display:'flex', alignItems:'center', justifyContent:'center', flexShrink:0 }}>
              {isLeaf
                ? <svg width="16" height="14" viewBox="0 0 16 14" fill="none"><path d="M1 1h5l2 2h7v10H1z" stroke={T.text3} strokeWidth="1.4" strokeLinejoin="round"/></svg>
                : <svg width="16" height="14" viewBox="0 0 16 14" fill="none"><path d="M1 3h5l2 2h7v8H1z" stroke={T.accent} strokeWidth="1.4" strokeLinejoin="round"/></svg>
              }
            </div>
            <div style={{ flex:1 }}>
              <div style={{ fontSize:14, color:T.text, fontWeight:500 }}>{node.name}</div>
              <div style={{ fontSize:11, color:T.text3, marginTop:1 }}>{isLeaf ? 'tracks' : `${node.children.length} items`}</div>
            </div>
            <svg width="7" height="12" viewBox="0 0 7 12" fill="none" stroke={T.text3} strokeWidth="1.5" strokeLinecap="round"><path d="M1 1l5 5-5 5"/></svg>
          </div>
        );
      })}
    </div>
  );

  if (embedded) return nodeList;

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100%', animation:'fadeIn 0.3s ease' }}>
      <SubScreenHeader title={current.node.name} subtitle="Browse Tree" onBack={handleBack}/>
      <div style={{ flex:1, overflowY:'auto', paddingBottom:88 }}>{nodeList}</div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// LIBRARY ROOT SCREEN
// ═══════════════════════════════════════════════════════════════
function LibraryScreen({ pushLib }) {
  const [tab, setTab] = React.useState('Artists');
  const [artistFilter, setArtistFilter] = React.useState('');
  const tabs = ['Artists','Random','Browse'];

  const filteredArtists = ARTISTS.filter(a => a.toLowerCase().includes(artistFilter.toLowerCase()));

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100%', animation:'fadeIn 0.3s ease' }}>
      <div style={{ padding:'56px 20px 12px', flexShrink:0 }}>
        <div style={{ fontFamily:T.mono, fontSize:9, letterSpacing:3, color:T.accent, textTransform:'uppercase', marginBottom:6 }}>Library</div>
        <div style={{ fontSize:24, fontWeight:700, color:T.text, letterSpacing:-0.5, marginBottom:14 }}>Browse</div>
        <div style={{ display:'flex', gap:4, background:T.bg2, borderRadius:10, padding:3 }}>
          {tabs.map(t => (
            <button key={t} onClick={()=>setTab(t)} style={{
              flex:1, height:32, borderRadius:8, border:'none', cursor:'pointer',
              fontSize:13, fontWeight:500, fontFamily:T.sans, transition:'all 0.2s',
              background: tab===t ? T.bg4 : 'transparent', color: tab===t ? T.text : T.text3,
            }}>{t}</button>
          ))}
        </div>
      </div>

      <div style={{ flex:1, overflowY:'auto', paddingBottom:148 }}>
        {tab==='Artists' && (
          <div>
            {/* Filter field */}
            <div style={{ position:'relative', padding:'8px 20px 4px' }}>
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={T.text3} strokeWidth="1.5"
                style={{ position:'absolute', left:32, top:'50%', transform:'translateY(-50%)' }}>
                <circle cx="6" cy="6" r="5"/><path d="M11 11l2 2" strokeLinecap="round"/>
              </svg>
              <input value={artistFilter} onChange={e=>setArtistFilter(e.target.value)} placeholder="Filter artists…"
                style={{ width:'100%', height:36, borderRadius:10, border:`1px solid ${T.line2}`,
                  background:T.bg2, color:T.text, fontSize:13, paddingLeft:34, outline:'none', fontFamily:T.sans }}/>
            </div>
            {filteredArtists.map((artist,i) => (
              <div key={i} onClick={()=>pushLib({screen:'artist', artist})}
                style={{ display:'flex', alignItems:'center', gap:14, padding:'12px 20px', borderBottom:`1px solid ${T.line}`, cursor:'pointer' }}>
                <div style={{ width:44, height:44, borderRadius:'50%', background:T.bg3, display:'flex', alignItems:'center',
                  justifyContent:'center', fontSize:16, color:T.accent, fontWeight:600, flexShrink:0 }}>{artist[0]}</div>
                <div style={{ flex:1 }}>
                  <div style={{ fontSize:14, color:T.text, fontWeight:500 }}>{artist}</div>
                  <div style={{ fontSize:11, color:T.text3, marginTop:2 }}>Jazz</div>
                </div>
                <svg width="7" height="12" viewBox="0 0 7 12" fill="none" stroke={T.text3} strokeWidth="1.5" strokeLinecap="round"><path d="M1 1l5 5-5 5"/></svg>
              </div>
            ))}
          </div>
        )}
        {tab==='Random' && (
          <RandomAlbumsScreen embedded onAlbum={album=>pushLib({screen:'album',album})}
            onFolder={folder=>pushLib({screen:'folder',folder})}/>
        )}
        {tab==='Browse' && (
          <BrowseScreen embedded/>
        )}
      </div>
    </div>
  );
}

Object.assign(window, { LibraryScreen, AlbumDetailScreen, ArtistAlbumsScreen, RandomAlbumsScreen, FolderTracksScreen, BrowseScreen, BrowseFilesScreen });

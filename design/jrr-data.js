// ─── SAMPLE DATA ─────────────────────────────────────────────
const TRACKS = [
  { id:1, title:'So What', artist:'Miles Davis', album:'Kind of Blue', year:'1959', duration:'9:22', trackNum:1, bitrate:'FLAC 24/192', path:'/Music/Jazz/Miles Davis/Kind of Blue/01 So What.flac' },
  { id:2, title:'Freddie Freeloader', artist:'Miles Davis', album:'Kind of Blue', year:'1959', duration:'9:46', trackNum:2, bitrate:'FLAC 24/192', path:'/Music/Jazz/Miles Davis/Kind of Blue/02 Freddie Freeloader.flac' },
  { id:3, title:'Blue in Green', artist:'Miles Davis', album:'Kind of Blue', year:'1959', duration:'5:37', trackNum:3, bitrate:'FLAC 24/192', path:'/Music/Jazz/Miles Davis/Kind of Blue/03 Blue in Green.flac' },
  { id:4, title:'All Blues', artist:'Miles Davis', album:'Kind of Blue', year:'1959', duration:'11:33', trackNum:4, bitrate:'FLAC 24/192', path:'/Music/Jazz/Miles Davis/Kind of Blue/04 All Blues.flac' },
  { id:5, title:'Flamenco Sketches', artist:'Miles Davis', album:'Kind of Blue', year:'1959', duration:'9:26', trackNum:5, bitrate:'FLAC 24/192', path:'/Music/Jazz/Miles Davis/Kind of Blue/05 Flamenco Sketches.flac' },
  { id:6, title:'Take Five', artist:'Dave Brubeck Quartet', album:'Time Out', year:'1959', duration:'5:24', trackNum:1, bitrate:'FLAC 16/44', path:'/Music/Jazz/Brubeck/Time Out/01 Take Five.flac' },
  { id:7, title:'Blue Rondo à la Turk', artist:'Dave Brubeck Quartet', album:'Time Out', year:'1959', duration:'6:44', trackNum:2, bitrate:'FLAC 16/44', path:'/Music/Jazz/Brubeck/Time Out/02 Blue Rondo.flac' },
  { id:8, title:'A Love Supreme Pt. I', artist:'John Coltrane', album:'A Love Supreme', year:'1965', duration:'7:44', trackNum:1, bitrate:'FLAC 24/96', path:'/Music/Jazz/Coltrane/A Love Supreme/01.flac' },
];

const ALBUMS = [
  { id:1, title:'Kind of Blue', artist:'Miles Davis', year:'1959', tracks:5, folder:'/Music/Jazz/Miles Davis/Kind of Blue' },
  { id:2, title:'A Love Supreme', artist:'John Coltrane', year:'1965', tracks:4, folder:'/Music/Jazz/Coltrane/A Love Supreme' },
  { id:3, title:'Time Out', artist:'Dave Brubeck Quartet', year:'1959', tracks:8, folder:'/Music/Jazz/Brubeck/Time Out' },
  { id:4, title:'Mingus Ah Um', artist:'Charles Mingus', year:'1959', tracks:9, folder:'/Music/Jazz/Mingus/Mingus Ah Um' },
  { id:5, title:'Sketches of Spain', artist:'Miles Davis', year:'1960', tracks:6, folder:'/Music/Jazz/Miles Davis/Sketches of Spain' },
  { id:6, title:'Giant Steps', artist:'John Coltrane', year:'1960', tracks:10, folder:'/Music/Jazz/Coltrane/Giant Steps' },
  { id:7, title:'The Shape of Jazz to Come', artist:'Ornette Coleman', year:'1959', tracks:6, folder:'/Music/Jazz/Coleman/Shape of Jazz' },
  { id:8, title:'Waltz for Debby', artist:'Bill Evans Trio', year:'1962', tracks:11, folder:'/Music/Jazz/Evans/Waltz for Debby' },
  { id:9, title:'Bitches Brew', artist:'Miles Davis', year:'1970', tracks:8, folder:'/Music/Jazz/Miles Davis/Bitches Brew' },
  { id:10, title:'My Favorite Things', artist:'John Coltrane', year:'1961', tracks:4, folder:'/Music/Jazz/Coltrane/My Favorite Things' },
];

const ARTISTS = [
  'Miles Davis','John Coltrane','Dave Brubeck Quartet','Charles Mingus','Bill Evans Trio','Ornette Coleman','Thelonious Monk','Herbie Hancock'
];

const ZONES = [
  { id:1, name:'Living Room', device:'JRiver Media Server', active:true, volume:72 },
  { id:2, name:'Studio', device:'Bluesound Node', active:false, volume:55 },
  { id:3, name:'Bedroom', device:'Airport Express', active:false, volume:40 },
];

const QUEUE = [
  { id:1, title:'So What', artist:'Miles Davis', duration:'9:22', current:true },
  { id:2, title:'Freddie Freeloader', artist:'Miles Davis', duration:'9:46' },
  { id:3, title:'Blue in Green', artist:'Miles Davis', duration:'5:37' },
  { id:4, title:'All Blues', artist:'Miles Davis', duration:'11:33' },
  { id:5, title:'Flamenco Sketches', artist:'Miles Davis', duration:'9:26' },
  { id:6, title:'Take Five', artist:'Dave Brubeck Quartet', duration:'5:24' },
  { id:7, title:'Strange Meadow Lark', artist:'Dave Brubeck Quartet', duration:'7:38' },
];

const BROWSE_TREE = [
  { id:'1', name:'Audio', children:[
    { id:'10', name:'Jazz', children:[
      { id:'100', name:'Miles Davis', children:[
        { id:'1000', name:'Kind of Blue', children:[] },
        { id:'1001', name:'Sketches of Spain', children:[] },
        { id:'1002', name:'Bitches Brew', children:[] },
      ]},
      { id:'101', name:'John Coltrane', children:[
        { id:'1010', name:'A Love Supreme', children:[] },
        { id:'1011', name:'Giant Steps', children:[] },
      ]},
      { id:'102', name:'Dave Brubeck Quartet', children:[
        { id:'1020', name:'Time Out', children:[] },
      ]},
    ]},
    { id:'11', name:'Classical', children:[
      { id:'110', name:'Bach', children:[] },
      { id:'111', name:'Beethoven', children:[] },
    ]},
    { id:'12', name:'Rock', children:[
      { id:'120', name:'Beatles', children:[] },
    ]},
  ]},
  { id:'2', name:'Playlists', children:[
    { id:'20', name:'Late Night Jazz', children:[] },
    { id:'21', name:'Morning Focus', children:[] },
  ]},
];

const SAVED_SERVERS = [
  { id:1, name:'Home Server', host:'192.168.1.10', port:52199, lastUsed:'Today 9:41' },
  { id:2, name:'Studio Mac', host:'192.168.1.25', port:52199, lastUsed:'Yesterday' },
];
